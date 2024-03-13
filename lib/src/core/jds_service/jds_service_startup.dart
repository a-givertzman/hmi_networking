import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/update_cache_from_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';

/// 
/// [JdsService] startup sequence.
class JdsServiceStartup {
  final JdsService _service;
  final DsClientCache? _cache;
  ///
  /// [JdsService] startup sequence.
  /// 
  /// If [cache] is provided, config from server will be saved to it.
  const JdsServiceStartup({
    required JdsService service,
    DsClientCache? cache,
  }) : 
    _service = service,
    _cache = cache;
  ///
  /// Pull points config from JDS service,
  /// save it to cache (if provided) 
  /// and subscribe for all of the points.
  Future<ResultF<void>> run() async {
    // await _service.authenticate('');
    final configResult = await _service.points();
    switch(configResult) {
      case Ok(value:final config):
        final cache = _cache;
        if(cache != null) {
          await UpdatePointsCacheFromJdsService(
            cache: cache,
            jdsService: _service,
          ).apply();
        }
        await _service.subscribe(config.names);
        return const Ok(null);
      case Err(:final error):
        return Err(error);
    }
  }
}