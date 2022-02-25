import 'dart:async';

import '../model/error_wrapper.dart';
import '../sinks/error_stream_sink.dart';
import 'flow_stream.dart';

class ErrorStreamTransformer<S> extends StreamTransformerBase<S, S> {
  /// The starting error of this [Stream]
  final ErrorWrapper error;

  /// Constructs a [StreamTransformer] which starts with the provided [error]
  /// and then outputs all events from the source [Stream].
  ErrorStreamTransformer(this.error);

  @override
  Stream<S> bind(Stream<S> stream) => forwardStream(
        stream,
        ErrorStreamSink(error),
      );
}