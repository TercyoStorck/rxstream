# RxStream

__RxStream__ basically is lite way for __BehaviorSubject__ from [RxDart](https://pub.dev/packages/rxdart).

## Usage

``` dart
final _counter = Rx<int>();
final _version = Rx('1.0.0');
```

Then use __StreamBuilder__ like always.

## Features

* `value` get the latest value.
* `hasError` verify if stream has error.
* All features from streamController.