
import 'dart:typed_data';

import 'package:hmi_core/hmi_core.dart';

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
  Result<bool> requestAll();
  /// Sending data to the socket, not bloking, buffered
  Future<Result<bool>> send(List<int> data);
  /// Just close the socket
  /// NOTE: Writes may be buffered, and may not be flushed by a call to close(). To flush all buffered writes, call flush() before calling close().
  Future close();
}
