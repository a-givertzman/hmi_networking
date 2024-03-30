import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';

/// 
/// [JdsService] startup sequence.
class JdsServiceStartup {
  static const _log = Log('JdsServiceStartup');
  final JdsService _service;
  final Duration _authRetryDelay;
  ///
  /// [JdsService] startup sequence.
  /// 
  /// Config from [service] will be saved to [cache].
  /// 
  /// [dsClient] will be subscribed on all points from [service] config.
  const JdsServiceStartup({
    required JdsService service,
    Duration authRetryDelay = const Duration(milliseconds: 1000),
  }) : 
    _service = service,
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
    _log.info('Requesting points config...');
    switch(await _service.points()) {
      case Ok(value:final configs):
        _log.info('Points config successfully pulled!');
        _log.info('Subscribing to received points...');
        final subscribeResult = await _service.subscribe(
          configs.names,
        );
        switch(subscribeResult) {
          case Ok():
            _log.info('Succsessfully subscribed!');
            return const Ok(null);
          case Err(:final error):
            _log.warning('Failed to subscribe');
            return Err(error);
        }
      case Err(:final error):
        _log.warning('Failed to pull points');
        return Err(error);
    }
  }
}