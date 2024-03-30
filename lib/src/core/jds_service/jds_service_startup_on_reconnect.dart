import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
import 'package:hmi_networking/src/core/non_repetitive_stream.dart';
/// 
/// [JdsService] cache update sequence.
class JdsServiceStartupOnReconnect {
  static const _log = Log('JdsServiceStartupOnReconnect');
  final Stream<DsDataPoint<int>> _connectionStatuses;
  final JdsServiceStartup _startup;
  bool _isConnected;
  bool _isStartupCompleted = true;
  StreamSubscription<bool>? _connectionSubscription;
  ///
  /// [JdsService] cache update sequence.
  JdsServiceStartupOnReconnect({
    required Stream<DsDataPoint<int>> connectionStatuses,
    required JdsServiceStartup startup,
    bool initialConnectionStatus = false,
  }) :
    _connectionStatuses = connectionStatuses,
    _startup = startup, 
    _isConnected = initialConnectionStatus;
  ///
  void run() {
    _connectionSubscription ??= NonRepetitiveStream(
      stream: _connectionStatuses.map(
        (point) {
          switch(point) {
            case DsDataPoint<int>(
              value: final connectionStatus, 
              status: DsStatus.ok, 
              cot: DsCot.inf,
            ):
              final isConnected = connectionStatus == DsStatus.ok.value;
              _isConnected = isConnected;
              return isConnected;
            case _: 
              return false;
          }
        },
      ),
    ).stream
    .where((_) => _isStartupCompleted)
    .listen((_) async {
      while(_isConnected) {
        _log.info('Entering startup loop...');
        _isStartupCompleted = false;
        if(await _startup.run() case Ok()) {
          _log.info('Startup completed! Exiting startup loop...');
          _isStartupCompleted = true;
          break;
        }
        _log.info('Startup failed! Starting next startup attempt...');
        _isStartupCompleted = true;
      }
    });
  }
  ///
  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
  }
}