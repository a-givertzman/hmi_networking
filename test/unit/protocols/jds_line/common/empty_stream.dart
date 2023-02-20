import 'dart:typed_data';
///
Stream<Uint8List> getDelayedEmptyStream() => Stream.fromFuture(
  Future.delayed(
    const Duration(milliseconds: 100), 
    () => Uint8List(0),
  ),
);