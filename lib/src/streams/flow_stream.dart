import 'dart:async';

import '../sinks/forwarding_sink.dart';

class FlowStream<T> extends Stream<T> {
  final Stream<T> Function() _factory;

  @override
  bool get isBroadcast => true;

  FlowStream(
    Stream<T> Function() streamFactory,
  ) : _factory = streamFactory;

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    Stream<T> stream;

    try {
      stream = _factory();
    } catch (e, s) {
      return Stream<T>.error(e, s).listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
    }

    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

Stream<R> forwardStream<T, R>(
  Stream<T> stream,
  ForwardingSink<T, R> connectedSink,
) {
  ArgumentError.checkNotNull(stream, 'stream');
  ArgumentError.checkNotNull(connectedSink, 'connectedSink');

  late StreamController<R> controller;
  late StreamSubscription<T> subscription;

  void runCatching(void Function() block) {
    try {
      block();
    } catch (e, s) {
      connectedSink.addError(controller, e, s);
    }
  }

  void onListen() {
    runCatching(() {
      connectedSink.onListen(controller);
    });

    subscription = stream.listen((data) {
      runCatching(() {
        connectedSink.add(controller, data);
      });
    }, onError: (Object e, StackTrace? st) {
      runCatching(() {
        connectedSink.addError(controller, e, st);
      });
    }, onDone: () {
      runCatching(() {
        connectedSink.close(controller);
      });
    });
  }

  Future<List<dynamic>> onCancel() {
    final onCancelSelfFuture = subscription.cancel();
    final onCancelConnectedFuture = connectedSink.onCancel(controller);
    final futures = <Future>[
      onCancelSelfFuture,
      if (onCancelConnectedFuture is Future) onCancelConnectedFuture,
    ];
    return Future.wait<dynamic>(futures);
  }

  controller = StreamController<R>.broadcast(
    onListen: onListen,
    onCancel: onCancel,
    sync: true,
  );

  return controller.stream;
}
