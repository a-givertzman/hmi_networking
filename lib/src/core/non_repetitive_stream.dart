import 'dart:async';
///
class NonRepetitiveStream<T> {
  final StreamController<T> _controller = StreamController<T>();
  late final StreamSubscription<T> _subscription;
  T? _lastValue;
  ///
  NonRepetitiveStream({
    required Stream<T> stream,
  }) {
    _subscription = stream.listen(
      (event) {
        if (_lastValue != event) {
          _lastValue = event;
          _controller.add(event);
        }
      },
      onError: (error, stackTrace) {
        _controller.addError(error, stackTrace);
      },
    );
  }
  ///
  Stream<T> get stream => _controller.stream;
  ///
  Future<void> dispose() {
    return _subscription.cancel();
  }
}