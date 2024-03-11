import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
///
class JdsServiceStartup {
  final JdsService _service;
  ///
  const JdsServiceStartup({
    required JdsService service,
  }) : _service = service;
  ///
  Future<ResultF<JdsPointConfigs>> run() async {
    // await _service.authenticate('');
    final configResult = await _service.points();
    switch(configResult) {
      case Ok(value:final config):
        await _service.subscribe(config.names);
        return Ok(config);
      case Err(:final error):
        return Err(error);
    }
  }
}