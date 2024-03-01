import 'package:hmi_core/hmi_core.dart';

/// 
/// Remembers latest values of each unique point.
abstract interface class DsClientCache {
  ///
  /// Map of all currently saved points with their signal names as keys.
  Future<Map<String, DsDataPoint>> get points;
  ///
  /// Add point to the cache.
  Future<void> add(DsDataPoint point);
  ///
  /// Add a collection of points to the cache.
  Future<void> addMany(Iterable<DsDataPoint> points);
}
