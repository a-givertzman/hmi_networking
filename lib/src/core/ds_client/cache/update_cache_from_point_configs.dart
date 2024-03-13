import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
/// 
/// [JdsService] cache update sequence.
class UpdatePointsCacheFromJdsService {
  final DsClientCache _cache;
  final JdsService _jdsService;
  ///
  /// [JdsService] cache update sequence.
  /// 
  /// [jdsService] - to pull config from.
  /// 
  /// [cache] - to save config to.
  const UpdatePointsCacheFromJdsService({
    required DsClientCache cache, 
    required JdsService jdsService,
  }) : 
    _cache = cache, 
    _jdsService = jdsService;
  ///
  /// Pull points config fron JDS service and 
  /// save default values of new poins if any appeared.
  Future<ResultF<void>> apply() async {
    final cachePointNames = (await _cache.getAll())
      .map((point) => point.name.toString()).toSet();
    switch(await _jdsService.points()) {
      case Ok(value:final pointConfigs):
        final configPointNames = pointConfigs.names.toSet();
        final newPointNames = configPointNames.where(
          (pointName) => !cachePointNames.contains(pointName),
        );
        await _cache.addMany(
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
        return const Ok(null);
      case Err(:final error):
        return Err(error);
    }
  }
}