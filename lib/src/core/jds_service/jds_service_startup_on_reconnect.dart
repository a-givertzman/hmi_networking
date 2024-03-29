import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
/// 
/// [JdsService] cache update sequence.
class JdsServiceStartupOnReconnect {
  final Stream<bool> _connectionStatuses;
  final JdsServiceStartup _startup;
  bool _isConnected;
  ///
  /// [JdsService] cache update sequence.
  /// 
  /// [jdsService] - to pull config from.
  /// 
  /// [cache] - to save config to.
  JdsServiceStartupOnReconnect({
    required Stream<DsDataPoint<int>> connectionStatuses,
    required JdsServiceStartup startup,
    bool initialConnectionStatus = false,
  }) :
    _connectionStatuses = connectionStatuses.map(
      (point) => switch(point) {
        DsDataPoint<int>(
          value: final connectionStatus, 
          status: DsStatus.ok, 
          cot: DsCot.inf,
        ) => connectionStatus == DsStatus.ok.value,
        _ => false
      },
    ),
    _startup = startup, 
    _isConnected = initialConnectionStatus;
  ///
  StreamSubscription<bool> run() {
    return _connectionStatuses.listen((isConnected) async {
      if(_isConnected != isConnected) {
        _isConnected = isConnected;
        await _startup.run();
      }
    });
  }
}