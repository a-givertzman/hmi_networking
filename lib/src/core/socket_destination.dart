import 'dart:io';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/request_destination.dart';
import 'entities/internet_endpoint.dart';
///
class SocketDestination implements RequestDestination<List<int>, List<int>> {
  final InternetEndpoint _address;
  final Duration _packageTimeout;
  ///
  const SocketDestination({
    required InternetEndpoint address,
    Duration packageTimeout = const Duration(milliseconds: 300),
  }) : 
    _address = address,
    _packageTimeout = packageTimeout;
  //
  @override
  Future<ResultF<List<int>>> send(List<int> data) async {
    try {
      final socket = await Socket.connect(_address.host, _address.port);
      socket.add(data);
      final receivedPackages = await socket.timeout(
        _packageTimeout,
        onTimeout: (sink) => sink.close(),
      ).toList();
      return Ok(
        receivedPackages
          .map((package) => package.toList())
          .expand((element) => element)
          .toList(),
      );
    } catch(e) {
      return Err(
        Failure(message: e.toString(), stackTrace: StackTrace.current),
      );
    }
  }  
}