import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';

///
/// Sends value of type [T] to the DataServer
class DsSend<T> {
  static const Map _types = {
    bool: DsDataType.bool,
    int: DsDataType.integer,
    double: DsDataType.real,
    String: DsDataType.string,
  };
  final DsClient _dsClient;
  final DsPointName _pointName;
  final DsCot _cot;
  final List<DsCot> _responseCots;
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
    required DsCot cot,
    required List<DsCot> responseCots,
    String? response,
    int responseTimeout = 5,
  }) : 
    assert(_types.containsKey(T)),
    _dsClient = dsClient,
    _pointName = pointName,
    _cot = cot,
    _responseCots = responseCots,
    _response = response,
    _responseTimeout = responseTimeout;
  ///
  Future<ResultF<DsDataPoint<T>>> exec(T value) {
    final responseStream = BufferedStream(
      _dsClient.stream<T>(_response ?? _pointName.name),
    );
    _dsClient.send(DsDataPoint(
      type: _types[T], 
      name: _pointName, 
      value: value,
      status: DsStatus.ok,
      cot: _cot,
      timestamp: DateTime.now().toUtc().toIso8601String(),
    ));
    return responseStream
      .stream
      .where((event) => _responseCots.contains(event.cot))
      .first
      .then<ResultF<DsDataPoint<T>>>((point) => point.toResult())
      .onError(
        (error, stackTrace) => Err(
          Failure(
            message: error.toString(), 
            stackTrace: stackTrace,
          ),
        ),
      )
      .timeout(
        Duration(seconds: _responseTimeout), 
        onTimeout: () => Err(
          Failure(
            message: 'Ошибка в методе $runtimeType.exec: Timeout exceeded ($_responseTimeout sec) on stream(${_response ?? _pointName.name})', 
            stackTrace: StackTrace.current,
          ),
        ),
      );
  }
}