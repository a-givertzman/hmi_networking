import 'dart:io';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/transport_protocol.dart';
import 'package:hmi_networking/src/protocols/transport_connection.dart';
import 'package:hmi_networking/src/protocols/tcp/tcp_connection.dart';
import 'package:hmi_networking/src/core/entities/web_address.dart';
///
/// Generates TCP connections to specified address.
class Tcp implements TransportProtocol {
  final WebAddress _address;
  final Duration? _packageTimeout;
  final Duration? _connectionTimeout;
  ///
  /// Generates [TcpConnection]s to the specified [address].
  /// 
  /// If [packageTimeout] is provided, connection will close after a specified period of inactivity from the connection.
  /// 
  /// [connectionTimeout] - wait period before determining that a connection attempt has failed.
  const Tcp({
    required WebAddress address,
    Duration? packageTimeout,
    Duration? connectionTimeout,
  }) : 
    _address = address,
    _packageTimeout = packageTimeout,
    _connectionTimeout = connectionTimeout;
  //
  @override
  Future<ResultF<TransportConnection>> establishConnection() {
    return Socket.connect(
      _address.host, 
      _address.port,
      timeout: _connectionTimeout,
    ).then<ResultF<TransportConnection>>(
      (socket) => Ok(
        TcpConnection(
          socket,
          packageTimeout: _packageTimeout,
        ),
      ),
    ).onError(
      (error, stackTrace) => Err(
      Failure(
        message: error.toString(),
        stackTrace: stackTrace,
      ),
      ),
    );
  }
}