import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/update_cache_from_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
/// 
/// [JdsService] cache update sequence.
class UpdateCacheOnReconnect {
  final Stream<DsDataPoint<bool>> _connectionStatuses;
  final UpdatePointsCacheFromJdsService _cacheUpdate;
  bool _isConnected;
  ///
  /// [JdsService] cache update sequence.
  /// 
  /// [jdsService] - to pull config from.
  /// 
  /// [cache] - to save config to.
  UpdateCacheOnReconnect({
    required Stream<DsDataPoint<bool>> connectionStatuses,
    required UpdatePointsCacheFromJdsService cacheUpdate,
    bool initialConnectionStatus = false,
  }) :
    _connectionStatuses = connectionStatuses,
    _cacheUpdate = cacheUpdate, 
    _isConnected = initialConnectionStatus;
  ///
  StreamSubscription<DsDataPoint<bool>> run() {
    return _connectionStatuses.listen((point) {
      if(point.value != _isConnected) {
        _isConnected = point.value;
        if(_isConnected && point.status == DsStatus.ok) {
          _cacheUpdate.apply();
        }
      }
    });
  }

}