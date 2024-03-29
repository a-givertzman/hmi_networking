import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
/// Sends value of type [T] to the DataServer
class DsSend<T> {
  static const Map _types = {
    bool: DsDataType.bool,
    int: DsDataType.integer,
    double: DsDataType.real,
  };
  final DsClient _dsClient;
  final DsPointName _pointName;
  final String? _response;
  final int _responseTimeout;
  ///
  /// [dsClient] - instance if DsClient 
  /// [pointName] - full name identifies DataServer Point
  /// [response] - name identifies DataServer Point to read written value
  /// if [response] not set then [name] will be used to read response
  /// [responseTimeout] - int, timeout in seconds to wait response
  DsSend({
    required DsClient dsClient,
    required DsPointName pointName,
    String? response,
    int responseTimeout = 10,
  }) : 
    assert(_types.containsKey(T)),
    _dsClient = dsClient,
    _pointName = pointName,
    _response = response,
    _responseTimeout = responseTimeout;
  ///
  Future<ResultF<DsDataPoint<T>>> exec(T value) {
    _dsClient.send(DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: _types[T], 
      name: _pointName.toString(), 
      value: value, 
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now(),
    ));
    final response = _response;
    return _dsClient.stream<T>(response ?? _pointName.name)
      .first
      .then<ResultF<DsDataPoint<T>>>((value) => Ok(value))
      .timeout(
        Duration(seconds: _responseTimeout), 
        onTimeout: () => Err(
          Failure(
            message: 'Ошибка в методе $runtimeType.exec: Timeout exceeded ($_responseTimeout sec) on stream(${response ?? _pointName.name})', 
            stackTrace: StackTrace.current,
          ),
        ),
      );
  }
}