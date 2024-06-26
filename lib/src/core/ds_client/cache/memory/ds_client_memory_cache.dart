import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';

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
  Future<Option<DsDataPoint>> get(DsPointName pointName) async {
    final point = _cache[pointName.toString()];
    return switch(point) {
      null => const None() as Option<DsDataPoint>, 
      _ => Some(point),
    };
  }
  //
  @override
  Future<List<DsDataPoint>> getAll() => Future.value(_cache.values.toList());
  //
  @override
  Future<void> add(DsDataPoint point) async {
    _cache[point.name.toString()] = point;
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    _cache.addEntries(
      points.map(
        (point) => MapEntry(point.name.toString(), point),
      ),
    );
  }
}