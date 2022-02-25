import 'dart:async';

import 'forwarding_sink.dart';

class StreamSink<S> implements ForwardingSink<S, S> {
  final S _startValue;
  var _isFirstEventAdded = false;

  StreamSink(this._startValue);

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
    if (!_isFirstEventAdded) {
      sink.add(_startValue);
      _isFirstEventAdded = true;
    }
  }
}
