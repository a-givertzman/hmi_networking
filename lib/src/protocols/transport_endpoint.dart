import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/transport_protocol.dart';
import 'package:hmi_networking/src/protocols/protocol_endpoint.dart';
/// 
/// Destination to send a request in bytes and receive an answer also in bytes through [TransportProtocol].
class TransportEndpoint implements ProtocolEndpoint<List<int>, List<int>> {
  final TransportProtocol _protocol;
  /// 
  /// Destination to send a request in bytes through [protocol] and receive an answer also in bytes.
  const TransportEndpoint({
    required TransportProtocol protocol,
  }) : 
    _protocol = protocol;
  // 
  @override
  Future<ResultF<List<int>>> exchange(List<int> data) async {
    switch(await _protocol.establishConnection()) {
      case Ok(value:final socket):
        socket.add(data);
        return socket.stream.toList()
          .then<ResultF<List<int>>>(
            (list) => Ok(list),
          )
          .catchError(
            (error, stackTrace) => Err<List<int>, Failure>(
              Failure(
                message: error.toString(),
                stackTrace: stackTrace,
              ),
            ),
          );
      case Err(:final error):
        return Err(error);
    }
  }
}