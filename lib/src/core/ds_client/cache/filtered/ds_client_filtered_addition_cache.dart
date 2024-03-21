import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
/// 
/// [DsClientCache] that checks condition before addition of point.
/// If that condition is false, point is not added/retrieved.
class DsClientAdditionFilteredCache implements DsClientCache {
  final DsClientCache _cache;
  final bool Function(DsDataPoint) _filter;
  ///
  /// [DsClientCache] that checks condition before addition of point.
  /// If that condition is false, point is not added.
  /// 
  /// [cache] - underlying cache to apply filtering to.
  const DsClientAdditionFilteredCache({
    required bool Function(DsDataPoint) filter,
    required DsClientCache cache,
  }) : 
    _filter = filter, 
    _cache = cache;
  //
  @override
  Future<void> add(DsDataPoint point) async {
    if(_filter(point)) {
      await _cache.add(point);
    }
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) {
    return _cache.addMany(points.where(_filter));
  }
  //
  @override
  Future<Option<DsDataPoint>> get(String pointName) => _cache.get(pointName);
  //
  @override
  Future<List<DsDataPoint>> getAll() => _cache.getAll();

}