import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_from_jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
/// 
/// [JdsService] cache update sequence.
class UpdateCacheOnReconnect {
  final Stream<DsDataPoint<bool>> _connectionStatuses;
  final UpdateCacheFromJdsService _cacheUpdate;
  bool _isConnected;
  ///
  /// [JdsService] cache update sequence.
  /// 
  /// [jdsService] - to pull config from.
  /// 
  /// [cache] - to save config to.
  UpdateCacheOnReconnect({
    required Stream<DsDataPoint<bool>> connectionStatuses,
    required UpdateCacheFromJdsService cacheUpdate,
    bool initialConnectionStatus = false,
  }) :
    _connectionStatuses = connectionStatuses,
    _cacheUpdate = cacheUpdate, 
    _isConnected = initialConnectionStatus;
  ///
  StreamSubscription<DsDataPoint<bool>> run() {
    return _connectionStatuses.listen((point) async {
      if(point.value != _isConnected) {
        _isConnected = point.value;
        if(_isConnected && point.status == DsStatus.ok) {
          await _cacheUpdate.apply();
        }
      }
    });
  }

}