import 'dart:async';

import 'package:hmi_core/hmi_core.dart';
import '../ds_client_cache.dart';

/// 
/// Remembers latest values of each unique point in RAM.
final class DsClientMemoryCache implements DsClientCache {
  final Map<String, DsDataPoint> _cache = {};
  /// 
  /// Remembers latest values of each unique point in RAM.
  DsClientMemoryCache({
    Map<String, DsDataPoint> initialCache = const {},
  }) {
    _cache.addAll(initialCache);
  }
  //
  @override
  Future<Map<String, DsDataPoint>> get points => Future.value(Map.unmodifiable(_cache));
  //
  @override
  Future<void> add(DsDataPoint point) async {
    _cache[point.name.name] = point;
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    _cache.addEntries(
      points.map(
        (point) => MapEntry(point.name.name, point),
      ),
    );
  }
}