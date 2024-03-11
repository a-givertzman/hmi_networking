import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_package/jds_package.dart';
import 'package:hmi_networking/src/core/request_destination.dart';
///
class JdsServiceDestination implements RequestDestination<JdsPackage, JdsPackage> {
  final RequestDestination<List<int>, List<int>> _bytesDestination;
  ///
  const JdsServiceDestination({
    required RequestDestination<List<int>, List<int>> bytesDestination,
  }) : _bytesDestination = bytesDestination;
  ///
  @override
  Future<ResultF<JdsPackage>> send(JdsPackage package) async {
    return switch(_encodeJson(package)) {      
      Ok(value: final bytes) => _decodeResult(await _bytesDestination.send(bytes)),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<JdsPackage> _decodeResult(ResultF<List<int>> bytesResult) => switch(bytesResult){
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