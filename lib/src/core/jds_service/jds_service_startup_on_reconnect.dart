import 'dart:async';
import 'package:async/async.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
/// 
/// [JdsService] cache update sequence.
class JdsServiceStartupOnReconnect {
  final Stream<DsDataPoint<int>> _connectionStatuses;
  final JdsServiceStartup _startup;
  bool _isConnected;
  StreamSubscription<bool>? _connectionSubscription;
  CancelableOperation? _startupProcess;
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
    _connectionSubscription ??= _connectionStatuses.map(
      (point) => switch(point) {
        DsDataPoint<int>(
          value: final connectionStatus, 
          status: DsStatus.ok, 
          cot: DsCot.inf,
        ) => connectionStatus == DsStatus.ok.value,
        _ => false
      },
    ).listen((isConnected) async {
      if(_isConnected != isConnected) {
        _isConnected = isConnected;
        await _startupProcess?.cancel();
        if(_isConnected) {
          _startupProcess = CancelableOperation.fromFuture(_startup.run());
        }
      }
    });
  }
  ///
  Future<void> cancel() async {
    await _connectionSubscription?.cancel();
    await _startupProcess?.cancel();
  }
}