import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/transport_endpoint.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_package.dart';
import 'package:hmi_networking/src/protocols/protocol_endpoint.dart';

/// 
/// Destination supporting JDS communication protocol.
class JdsEndpoint implements ProtocolEndpoint<JdsPackage, JdsPackage> {
  final TransportEndpoint _tansportEndpoint;
  ///
  /// Destination supporting JDS communication protocol.
  /// 
  /// [transportEndpoint] - binary destination to transfer serialized JDS packages over it.
  const JdsEndpoint({
    required TransportEndpoint transportEndpoint,
  }) : _tansportEndpoint = transportEndpoint;
  //
  @override
  Future<ResultF<JdsPackage>> exchange(JdsPackage package) async {
    return switch(_encodeJson(package)) {      
      Ok(value: final bytes) => _decodeResult(await _tansportEndpoint.exchange(bytes)),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<JdsPackage> _decodeResult(ResultF<List<int>> bytesResult) => switch(bytesResult) {
    Ok(value:final bytes) => _decodeJson(bytes),
    Err(:final error) => Err(error),
  };
  ///
  ResultF<JdsPackage> _decodeJson(List<int> bytes) {
    try {
      return Ok(
        JdsPackage.fromMap(
          json.decode(
            utf8.decode(bytes),
          ),
        ),
      );
    } catch(error){
      return Err(
        Failure(
          message: 'Failed to decode json: $error', 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  ResultF<List<int>> _encodeJson(JdsPackage package) {
    try {
      return Ok(
        utf8.encode(
          json.encode(package.toMap()),
        ),
      );
    } catch(error){
      return Err(
        Failure(
          message: 'Failed to encode json: $error', 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}