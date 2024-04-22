import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';

/// 
/// [JdsService] startup sequence.
class JdsServiceStartup {
  static const _log = Log('JdsServiceStartup');
  final JdsService _service;
  ///
  /// Jds [service] startup sequence.
  const JdsServiceStartup({
    required JdsService service,
  }) : 
    _service = service;
  ///
  /// Pull points config from JDS service,
  /// save it to cache (if provided) 
  /// and subscribe for all of the points.
  Future<ResultF<void>> run() async {
    _log.info('Authenticating...');
    switch(await _service.authenticate('12345')) {
      case Ok():
        _log.info('Authenticated successfully!');
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
      case Err(:final error):
        _log.warning('Failed to authenticate.');
        return Err(error);
    }
  }
}