import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_package/jds_cot.dart';
import 'package:hmi_networking/src/core/jds_service/jds_package/jds_data_type.dart';
import 'package:hmi_networking/src/core/jds_service/jds_package/jds_package.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/request_destination.dart';
///
class JdsService {
  final RequestDestination<JdsPackage, JdsPackage> _jdsDestination;
  ///
  const JdsService({
    required RequestDestination<JdsPackage, JdsPackage> jdsDestination,
  }) : 
    _jdsDestination = jdsDestination;
  ///
  Future<ResultF<void>> authenticate(String token) {
    return _jdsDestination.send(
      JdsPackage(
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
    });
  }
  ///
  Future<ResultF<JdsPointConfigs>> points() {
    return _jdsDestination.send(
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
    .then((result) async {
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
    });
  }
  ///
  Future<ResultF<void>> subscribe([List<String> names = const []]) {
    return _jdsDestination.send(
      JdsPackage<String>(
        type: JdsDataType.string, 
        value: '[${names.join(',')}]', 
        name: DsPointName('/App/Jds/Subscribe'), 
        status: DsStatus.ok, 
        cot: JdsCot.req, 
        timestamp: DateTime.now(),
      ),
    ).then((result) => switch(result) {
      Ok(value:final package) => package.toResult(),
      Err(:final error) => Err(error),
    });
  }
}