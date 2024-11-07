import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_json.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'package:hmi_networking/src/core/entities/point_route.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';

///
/// Collection of JDS requests supported by service on external server.
class JdsService {
  final DsClient _dsClient;
  final PointRoute _route;
  final Duration _responseTimeout;
  ///
  /// Collection of JDS requests supported by service on external server.
  /// 
  /// [endpoint] - to communicate through JDS protocol.
  const JdsService({
    required DsClient dsClient,
    PointRoute route = const PointRoute.empty(),
    Duration responseTimeout = const Duration(milliseconds: 500),
  }) : 
    _dsClient = dsClient,
    _responseTimeout = responseTimeout,
    _route = route;
  ///
  /// Proceed to authentication process with [token].
  Future<ResultF<void>> authenticate(String token) {
    return DsSend<String>(
      dsClient: _dsClient, 
      pointName: _route.join(DsPointName('/Auth.Secret')),
      cot: DsCot.req, 
      responseCots: [DsCot.reqCon, DsCot.reqErr],
      responseTimeout: _responseTimeout,
    ).exec(token)
    .onError(
      (error, stackTrace) => Err(
        Failure(
          message: error.toString(), 
          stackTrace: stackTrace,
        ),
      ),
    );
  }
  ///
  /// Get configuration of data points from the server.
  Future<ResultF<JdsPointConfigs>> points() {
    return DsSend<String>(
      dsClient: _dsClient, 
      pointName: _route.join(DsPointName('/Points')),
      cot: DsCot.req, 
      responseCots: [DsCot.reqCon, DsCot.reqErr],
      responseTimeout: _responseTimeout,
    ).exec('')
    .then<ResultF<JdsPointConfigs>>((result) async {
      switch(result) {
        case Ok(value:final point):
          final parsingResult = await JsonMap.fromString(point.value).decoded;
          return switch(parsingResult) {
            Ok(value: final map) => Ok(JdsPointConfigs.fromMap(map)),
            Err(:final error) => Err(error),
          };
        case Err(:final error):
          return Err(error);
      }
    })
    .onError(
      (error, stackTrace) => Err(
        Failure(
          message: error.toString(), 
          stackTrace: stackTrace,
        ),
      ),
    );
  }
  ///
  /// Tell server to send specific data points.
  Future<ResultF<void>> subscribe([List<String> names = const []]) {
    return DsSend<String>(
      dsClient: _dsClient, 
      pointName: _route.join(DsPointName('/Subscribe')),
      cot: DsCot.req, 
      responseCots: [DsCot.reqCon, DsCot.reqErr],
      responseTimeout: _responseTimeout,
    ).exec('[${names.map((name) => '"$name"').join(',')}]')
    .onError(
      (error, stackTrace) => Err(
        Failure(
          message: error.toString(), 
          stackTrace: stackTrace,
        ),
      ),
    );
  }
}