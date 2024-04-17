import 'package:hmi_core/hmi_core.dart';

/// 
/// Remembers latest values of each unique point.
abstract interface class DsClientCache {
  ///
  /// Retrieves point from cache by its name.
  Future<Option<DsDataPoint>> get(DsPointName pointName);
  ///
  /// Retrieves all points from cache.
  Future<List<DsDataPoint>> getAll();
  ///
  /// Add point to the cache.
  Future<void> add(DsDataPoint point);
  ///
  /// Add a collection of points to the cache.
  Future<void> addMany(Iterable<DsDataPoint> points);
}
