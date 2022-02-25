import 'dart:async' hide StreamSink;

import '../sinks/stream_sink.dart';
import 'flow_stream.dart';

class StreamTransformer<S> extends StreamTransformerBase<S, S> {
  /// The starting event of this [Stream]
  final S startValue;

  /// Constructs a [StreamTransformer] which prepends the source [Stream]
  /// with [startValue].
  StreamTransformer(this.startValue);

  @override
  Stream<S> bind(Stream<S> stream) => forwardStream(
        stream,
        StreamSink(startValue),
      );
}
