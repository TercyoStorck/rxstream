import 'dart:async';

import '../model/error_wrapper.dart';
import 'forwarding_sink.dart';

class ErrorStreamSink<S> implements ForwardingSink<S, S> {
  final ErrorWrapper _e;
  var _isFirstEventAdded = false;

  ErrorStreamSink(this._e);

  @override
  void add(EventSink<S> sink, S data) {
    _safeAddFirstEvent(sink);
    sink.add(data);
  }

  @override
  void addError(EventSink<S> sink, Object e, [StackTrace? st]) {
    _safeAddFirstEvent(sink);
    sink.addError(e, st);
  }

  @override
  void close(EventSink<S> sink) {
    _safeAddFirstEvent(sink);
    sink.close();
  }

  @override
  FutureOr onCancel(EventSink<S> sink) {}

  @override
  void onListen(EventSink<S> sink) {
    scheduleMicrotask(() => _safeAddFirstEvent(sink));
  }

  @override
  void onPause(EventSink<S> sink) {}

  @override
  void onResume(EventSink<S> sink) {}

  void _safeAddFirstEvent(EventSink<S> sink) {
    if (_isFirstEventAdded) return;
    sink.addError(_e.error, _e.stackTrace);
    _isFirstEventAdded = true;
  }
}