import 'dart:async';

abstract class ForwardingSink<T, R> {
  /// Handle data event
  void add(EventSink<R> sink, T data);

  /// Handle error event
  void addError(EventSink<R> sink, Object error, [StackTrace? st]);

  /// Handle close event
  void close(EventSink<R> sink);

  /// Fires when a listener subscribes on the underlying [Stream].
  void onListen(EventSink<R> sink);

  /// Fires when a subscriber pauses.
  void onPause(EventSink<R> sink);

  /// Fires when a subscriber resumes after a pause.
  void onResume(EventSink<R> sink);

  /// Fires when a subscriber cancels.
  FutureOr onCancel(EventSink<R> sink);
}