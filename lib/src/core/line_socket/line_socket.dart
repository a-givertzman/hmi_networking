
import 'dart:typed_data';
import 'package:hmi_core/hmi_core_result.dart';

/// 
/// Listen socket, send to socket,
/// Keep alive connection
abstract class LineSocket {
  /// 
  bool get isConnected;
  ///
  bool get isActive;
  /// stream of all data coming from the socket
  Stream<Uint8List> get stream;
  ///
  ResultF<void> requestAll();
  /// Sending data to the socket, not blocking, buffered
  Future<ResultF<void>> send(List<int> data);
  /// Just closes the socket
  /// 
  /// NOTE: Writes may be buffered, and may not be flushed by a call to close(). To flush all buffered writes, call flush() before calling close().
  Future<void> close();
}
