# RxStream

[![Pub Version](https://img.shields.io/pub/v/rxstream)](https://pub.dev/packages/rxstream)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

**RxStream** is a lightweight, efficient abstraction over `StreamController` that mimics the behavior of `BehaviorSubject` from RxDart. It provides a simple way to manage state and streams in Flutter applications without the overhead of the full RxDart library.

## Why RxStream?

- 🚀 **Lightweight**: No heavy dependencies, just a simple wrapper around core Dart streams.
- 🔄 **Behavior-like**: Remembers the latest value or error and emits it immediately to new listeners.
- 📡 **Broadcast by Default**: All `Rx` streams are broadcast streams, perfect for multiple UI listeners.
- 🛠 **Familiar API**: Implements `StreamController<T>`, so it fits perfectly into existing codebases.

## Getting Started

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  rxstream: ^1.0.0
```

## Usage

### Basic Initialization

You can initialize an `Rx` stream with or without an initial value.

```dart
import 'package:rxstream/rxstream.dart';

// With initial value
final version = Rx<String>('1.0.0');

// Without initial value (starts as null)
final counter = Rx<int>();
```

### Adding Events and Errors

Updating the stream is as simple as calling `add` or `addError`.

```dart
counter.add(10);
print(counter.value); // Outputs: 10

counter.addError('Something went wrong');
print(counter.hasError); // Outputs: true
```

### Integration with Flutter (StreamBuilder)

Since `Rx` provides a standard `Stream`, it works seamlessly with `StreamBuilder`.

```dart
StreamBuilder<int>(
  stream: counter.stream,
  builder: (context, snapshot) {
    if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    return Text('Count: ${snapshot.data}');
  },
)
```

## Features & API

- `value`: Returns the current value of the stream.
- `hasError`: Returns `true` if the last event added was an error.
- `error`: Returns the `ErrorWrapper` containing the last error and its stack trace.
- `stream`: Returns the `Stream<T>` that emits events.
- `sink`: Returns the `StreamSink<T>` to add events.

## Example

Check out the [example](example/lib/main.dart) directory for a complete Flutter counter app implementation.

---

## License

This project is licensed under the GNU GPL v3 License - see the [LICENSE](LICENSE) file for details.