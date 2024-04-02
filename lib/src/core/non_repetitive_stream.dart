import 'dart:async';

import 'package:hmi_core/hmi_core_option.dart';
bool _defaultIsEqual(Object? a, Object? b) => a == b;
///
class NonRepetitiveStream<T> {
  final StreamController<T> _controller = StreamController<T>();
  late final StreamSubscription<T> _subscription;
  final bool Function(T, T) _isEqual;
  Option<T> _lastValue = const None();
  ///
  NonRepetitiveStream({
    required Stream<T> stream,
    bool Function(T last, T next) isEqual = _defaultIsEqual,
  }) : 
    _isEqual = isEqual {
    _subscription = stream.listen(
      (event) {
        final isEqual = switch(_lastValue) {
          Some<T>(:final value) => _isEqual(value, event),
          None() => false,
        };
        if (!isEqual) {
          _lastValue = Some(event);
          _controller.add(event);
        }
      },
      onError: (error, stackTrace) {
        _controller.addError(error, stackTrace);
      },
      onDone: () => _controller.close(),
    );
  }
  ///
  Stream<T> get stream => _controller.stream;
  ///
  Future<void> dispose() {
    return _subscription.cancel();
  }
}