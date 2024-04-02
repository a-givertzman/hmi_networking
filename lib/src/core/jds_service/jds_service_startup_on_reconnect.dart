import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
/// 
/// [JdsService] cache update sequence.
class JdsServiceStartupOnReconnect {
  static const _log = Log('JdsServiceStartupOnReconnect');
  final Stream<DsDataPoint<int>> _connectionStatuses;
  final JdsServiceStartup _startup;
  bool _isConnected = true;
  bool _isStartupCompleted = false;
  StreamSubscription? _connectionSubscription;
  ///
  /// [JdsService] cache update sequence.
  JdsServiceStartupOnReconnect({
    required Stream<DsDataPoint<int>> connectionStatuses,
    required JdsServiceStartup startup,
  }) :
    _connectionStatuses = connectionStatuses,
    _startup = startup;
  ///
  Future<void> run() async {
    _connectionSubscription = _connectionStatuses.listen((point) {
      _log.info('ConnectionStatus: status: ${point.status}');
      if (point.status == DsStatus.ok) {
        _log.info('ConnectionStatus: value : ${point.value} (${DsStatus.ok.value})');
        final connectionStatus = '${point.value}';
        if (connectionStatus == '${DsStatus.ok.value}') {
          _log.info('ConnectionStatus: is connected!');
          _isConnected = true;
        } else {
          _log.info('ConnectionStatus: is not connected.');
          _isConnected = false;
          _isStartupCompleted = false;
        }
      } else {
        _log.info('ConnectionStatus: is not connected.');
        _isConnected = false;
        _isStartupCompleted = false;
      }
    });
    _log.info('Entering startup loop...');
    while (true) {
      _log.info('_isConnected: $_isConnected');
      _log.info('_isStartupCompleted: $_isStartupCompleted');
      if (_isConnected && !_isStartupCompleted) {
        _log.info('Starting up...');
        final result = await _startup.run();
        _isStartupCompleted = switch (result) {
          Ok() => true,
          Err() => false,
        };
        _log.info('Startup completed, result: $result');
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }
  ///
  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
  }
}