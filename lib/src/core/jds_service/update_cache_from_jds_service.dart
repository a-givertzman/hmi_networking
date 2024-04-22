import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/hmi_networking.dart';
/// 
/// [JdsService] cache update sequence.
class UpdateCacheFromJdsService {
  final DsClientCache _cache;
  final JdsService _jdsService;
  ///
  /// [JdsService] cache update sequence.
  /// 
  /// [jdsService] - to pull config from.
  /// 
  /// [cache] - to save config to.
  UpdateCacheFromJdsService({
    required DsClientCache cache,
    required JdsService jdsService,
  }) :
    _cache = cache, 
    _jdsService = jdsService;
  ///
  /// Pull points config fron JDS service and 
  /// save default values of new poins if any appeared.
  /// 
  /// Returns map with all points names currently availible,
  /// where short point names as keys and full point paths as values.
  Future<ResultF<Map<String, DsPointName>>> apply() async {
    switch(await _jdsService.points()) {
      case Ok(value:final pointConfigs):
        final cachePoints = await _cache.getAll();
        final cachedNames = {
          for(final point in cachePoints)
            point.name.name: point.name,
        };
        final configNames = {
          for(final pointName in pointConfigs.names.map((name) => DsPointName(name)))
            pointName.name: pointName,
        };
        final cacheNamesSet = cachedNames.keys.toSet();
        final configNamesSet = configNames.keys.toSet();
        final newPointNames = configNamesSet.where(
          (pointName) => !cacheNamesSet.contains(pointName),
        );
        await _cache.addMany(
          newPointNames.map(
            (pointName) => DsDataPoint(
              type: DsDataType.integer,
              name: configNames[pointName]!,
              value: 0,
              status: DsStatus.invalid,
              cot: DsCot.inf,
              timestamp: DsTimeStamp.now().toString(),
            ),
          ),
        );
        return Ok({
          ...cachedNames,
          ...configNames,
        });
      case Err(:final error):
        return Err(error);
    }
  }
}