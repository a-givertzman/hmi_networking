import 'dart:async';
import 'dart:io';
import 'package:hmi_networking/src/protocols/transport_connection.dart';
///
/// [TransportConnection] through TCP protocol.
class TcpConnection implements TransportConnection {
  final Socket _socket;
  final Duration? _packageTimeout;
  /// [TransportConnection] through TCP protocol.
  /// 
  /// [socket] - TCP socket to communicate through.
  /// 
  /// If [packageTimeout] is provided, connection will close after a specified period of inactivity from [socket].
  const TcpConnection(
    Socket socket, {
    Duration? packageTimeout,
  }) : 
    _socket = socket,
    _packageTimeout = packageTimeout;
  //
  @override
  void add(List<int> data) => _socket.add(data);
  //
  @override
  void close() => _socket.close();
  //
  @override
  Stream<int> get stream {
    final packageTimeout = _packageTimeout;
    final stream = _socket.expand(
      (batch) => batch.toList(),
    );
    return packageTimeout == null
      ? stream
      : stream
      .timeout(
        packageTimeout,
        onTimeout: (_) async {
          await _socket.flush();
          close();
        },
      );
  }
}