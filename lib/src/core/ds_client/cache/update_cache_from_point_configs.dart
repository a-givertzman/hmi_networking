import 'package:hmi_core/hmi_core.dart';
import 'ds_client_cache.dart';
import '../../jds_service/jds_point_config/jds_point_configs.dart';
///
class UpdateCacheFromPointConfigs {
  final DsClientCache _cache;
  final JdsPointConfigs _configs;
  ///
  const UpdateCacheFromPointConfigs({
    required DsClientCache cache, 
    required JdsPointConfigs configs,
  }) : _cache = cache, _configs = configs;
  ///
  Future<void> apply() async {
    final cachePointNames = (await _cache.getAll())
          .map((point) => point.name.toString()).toSet();
    final configPointNames = _configs.names.toSet();
    final newPointNames = configPointNames.where(
      (pointName) => !cachePointNames.contains(pointName),
    );
    _cache.addMany(
      newPointNames.map(
        (pointName) => DsDataPoint(
          type: DsDataType.integer,
          name: DsPointName(pointName),
          value: 0,
          status: DsStatus.invalid,
          timestamp: DsTimeStamp.now().toString(),
        ),
      ),
    );
  }
}