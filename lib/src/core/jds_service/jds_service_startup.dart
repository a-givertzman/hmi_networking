import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_from_jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';

/// 
/// [JdsService] startup sequence.
class JdsServiceStartup {
  static const _log = Log('JdsServiceStartup');
  final JdsService _service;
  final DsClientCache _cache;
  final DsClient _dsClient;
  final Duration _authRetryDelay;
  ///
  /// [JdsService] startup sequence.
  /// 
  /// Config from [service] will be saved to [cache].
  /// 
  /// [dsClient] will be subscribed on all points from [service] config.
  const JdsServiceStartup({
    required DsClient dsClient,
    required JdsService service,
    required DsClientCache cache,
    Duration authRetryDelay = const Duration(milliseconds: 1000),
  }) : 
    _service = service,
    _cache = cache,
    _authRetryDelay = authRetryDelay,
    _dsClient = dsClient;
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
    final configResult = await UpdateCacheFromJdsService(
      cache: _cache,
      jdsService: _service,
    ).apply();
    switch(configResult) {
      case Ok(value:final config):
        _log.info('Points config successfully pulled!');
        _log.info('Subscribing to received points...');
        final subscribeResult = await _service.subscribe(
          config.values.map((pointName) => pointName.toString()).toList(),
        );
        switch(subscribeResult) {
          case Ok():
            for(final name in config.keys) {
              _dsClient.stream<String>(name);       
            }
            return const Ok(null);
          case Err(:final error):
            return Err(error);
        }
      case Err(:final error):
        _log.warning('Failed to pull points');
        return Err(error);
    }
  }
}