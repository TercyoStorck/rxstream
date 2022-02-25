import 'dart:async' hide StreamTransformer;

import 'model/error_wrapper.dart';
import 'streams/error_stream_transformer.dart';
import 'streams/flow_stream.dart';
import 'streams/stream_transformer.dart';

class Rx<T> implements StreamController<T> {
  late StreamController<T> _controller;
  late Stream<T> _stream;
  T? _value;
  ErrorWrapper? _errorWrapper;

  Rx([T? value]) {
    _value = value;
    _controller = StreamController<T>.broadcast();
    _stream = FlowStream<T>(_flowStreamFunction);
  }

  T? get value => _value;
  bool get hasError => _errorWrapper != null;

  @override
  FutureOr<void> Function()? onCancel;

  @override
  void Function()? onListen;

  @override
  void Function()? onPause;

  @override
  void Function()? onResume;

  @override
  void add(T event) {
    _controller.add(event);
    _value = event;
    _errorWrapper = null;
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
    _errorWrapper = ErrorWrapper(error, stackTrace);
  }

  @override
  Future addStream(Stream<T> source, {bool? cancelOnError}) {
    return _controller.addStream(source, cancelOnError: cancelOnError);
  }

  @override
  Future close() {
    return _controller.close();
  }

  @override
  Future get done => _controller.done;

  @override
  bool get hasListener => _controller.hasListener;

  @override
  bool get isClosed => _controller.isClosed;

  @override
  bool get isPaused => _controller.isPaused;

  @override
  StreamSink<T> get sink => _controller.sink;

  @override
  Stream<T> get stream => _stream;

  Stream<R> map<R>(R Function(T event) convert) {
    return _controller.stream.map(convert);
  }

  Stream<T> Function() get _flowStreamFunction {
    return () {
      if (_errorWrapper != null) {
        return _controller.stream.transform(
          ErrorStreamTransformer(
            _errorWrapper!,
          ),
        );
      }

      if (_value != null) {
        return _controller.stream.transform(
          StreamTransformer<T>(_value!),
        );
      }

      return _controller.stream;
    };
  }
}














