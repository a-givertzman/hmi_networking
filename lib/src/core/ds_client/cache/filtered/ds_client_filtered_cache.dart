import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
/// 
/// [DsClientCache] that checks condition before addition or (optionally) retrievement of point.
/// If that condition is false, point is not added/retrieved.
class DsClientFilteredCache implements DsClientCache {
  final DsClientCache _cache;
  final bool Function(DsDataPoint) _filter;
  final bool _filterOnGet;
  ///
  /// [DsClientCache] that checks condition before addition or (optionally) retrievement of point.
  /// If that condition is false, point is not added/obtained.
  /// 
  /// [cache] - underlying cache to apply filtering to.
  /// 
  /// [filterOnGet] - should filtering be applied to obtain data?
  const DsClientFilteredCache({
    required bool Function(DsDataPoint) filter,
    required DsClientCache cache,
    bool filterOnGet = false,
  }) :
    _filter = filter,
    _cache = cache,
    _filterOnGet = filterOnGet;
  
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
  Future<Option<DsDataPoint>> get(DsPointName pointName) async {
    final option = await _cache.get(pointName);
    return switch(option) {
      Some(value:final point) => switch(_filterOnGet) {
        true => _filter(point) 
          ? Some(point) 
          : const None() as Option<DsDataPoint>,
        false => Some(point),
      },
      None() => const None(),
    };
  }
  @override
  Future<List<DsDataPoint>> getAll() {
    return _cache.getAll()
      .then((points) => switch(_filterOnGet) {
        true => points.where(_filter).toList(),
        false => points,
      });
  }

}