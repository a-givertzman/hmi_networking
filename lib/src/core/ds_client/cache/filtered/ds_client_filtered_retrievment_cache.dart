import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
/// 
/// [DsClientCache] that checks condition before retrievement of point.
/// If that condition is false, point is not retrieved.
class DsClientFilteredRetrievementCache implements DsClientCache {
  final DsClientCache _cache;
  final bool Function(DsDataPoint) _filter;
  ///
  /// [DsClientCache] that checks condition before retrievement of point.
  /// If that condition is false, point is not retrieved.
  /// 
  /// [cache] - underlying cache to apply filtering to.
  const DsClientFilteredRetrievementCache({
    required bool Function(DsDataPoint) filter,
    required DsClientCache cache,
  }) : 
    _filter = filter, 
    _cache = cache;
  
  //
  @override
  Future<void> add(DsDataPoint point) => _cache.add(point);
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) => _cache.addMany(points);
  //
  @override
  Future<Option<DsDataPoint>> get(String pointName) async {
    final option = await _cache.get(pointName);
    return switch(option) {
      Some(value:final point) => _filter(point) 
          ? Some(point) 
          : const None() as Option<DsDataPoint>,
      None() => const None(),
    };
  }
  @override
  Future<List<DsDataPoint>> getAll() {
    return _cache.getAll()
      .then(
        (points) => points.where(_filter).toList(),
      );
  }
}