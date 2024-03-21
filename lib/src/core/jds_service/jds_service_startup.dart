import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_from_jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';

/// 
/// [JdsService] startup sequence.
class JdsServiceStartup {
  static const _log = Log('JdsServiceStartup');
  final JdsService _service;
  final DsClientCache? _cache;
  final Duration _authRetryDelay;
  ///
  /// [JdsService] startup sequence.
  /// 
  /// If [cache] is provided, config from server will be saved to it.
  const JdsServiceStartup({
    required JdsService service,
    DsClientCache? cache,
    Duration authRetryDelay = const Duration(milliseconds: 1000),
  }) : 
    _service = service,
    _cache = cache,
    _authRetryDelay = authRetryDelay;
  ///
  /// Pull points config from JDS service,
  /// save it to cache (if provided) 
  /// and subscribe for all of the points.
  Future<ResultF<void>> run() async {
    _log.info('Authenting...');
    while(await _service.authenticate('12345') is Err) {
      _log.warning('Unable to authenticate.');
      await Future.delayed(_authRetryDelay);
      _log.warning('Retrying...');
    }
    _log.info('Pulling points config...');
    final configResult = await _service.points();
    switch(configResult) {
      case Ok(value:final config):
        _log.info('Points config successfully pulled!');
        final cache = _cache;
        if(cache != null) {
          await UpdateCacheFromJdsService(
            cache: cache,
            jdsService: _service,
          ).apply();
        }
        _log.info('Subscribing to received points...');
        return _service.subscribe(config.names);
      case Err(:final error):
        _log.warning('Failed to pull points');
        return Err(error);
    }
  }
}