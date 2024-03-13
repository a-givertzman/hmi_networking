import 'dart:async';
///
/// Connection over binary exchange protocol. 
abstract interface class TransportConnection implements Sink<List<int>> {
  /// 
  /// Flow of bytes from the connection.
  Stream<int> get stream;
}