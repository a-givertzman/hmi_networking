import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/hmi_networking.dart';

///
/// Collection of JDS requests supported by service on external server.
class JdsService {
  final JdsEndpoint _endpoint;
  ///
  /// Collection of JDS requests supported by service on external server.
  /// 
  /// [endpoint] - to communicate through JDS protocol.
  const JdsService({
    required JdsEndpoint endpoint,
  }) : 
    _endpoint = endpoint;
  ///
  /// Proceed to authentication process with [token].
  Future<ResultF<void>> authenticate(String token) {
    return _endpoint.exchange(
      JdsPackage<String>(
        type: JdsDataType.string,
        value: token,
        name: DsPointName('/App/Jds/Authenticate'),
        status: DsStatus.ok,
        cot: JdsCot.req,
        timestamp: DateTime.now(),
      ),
    ).then((result) => switch(result) {
      Ok(value:final package) => package.toResult(),
      Err(:final error) => Err(error),
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
  /// Get configuration of data points from the server.
  Future<ResultF<JdsPointConfigs>> points() {
    return _endpoint.exchange(
      JdsPackage<String>(
        type: JdsDataType.string,
        value: '',
        name: DsPointName('/App/Jds/Points'),
        status: DsStatus.ok,
        cot: JdsCot.req,
        timestamp: DateTime.now(),
      ),
    )
    .then((result) => switch(result) {
      Ok(value: final package) => package.toResult(),
      Err(:final error) => Err(error),
    })
    .then<ResultF<JdsPointConfigs>>((result) async {
      switch(result) {
        case Ok(:final value):
          final parsingResult = await JsonMap.fromString(value).decoded;
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
    return _endpoint.exchange(
      JdsPackage<String>(
        type: JdsDataType.string,
        value: '[${names.map((name) => '"$name"').join(',')}]',
        name: DsPointName('/App/Jds/Subscribe'),
        status: DsStatus.ok,
        cot: JdsCot.req,
        timestamp: DateTime.now(),
      ),
    )
    .then((result) => switch(result) {
      Ok(value:final package) => package.toResult(),
      Err(:final error) => Err(error),
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
}