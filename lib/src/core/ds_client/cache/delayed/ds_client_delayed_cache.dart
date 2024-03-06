import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_file_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

/// 
/// Periodically persists primary cache into secondary. 
final class DsClientDelayedCache implements DsClientCache {
  final DsClientCache _primaryCache;
  final DsClientCache _secondaryCache;
  final Duration _cachingTimeout;
  Timer? _timer;
  /// 
  /// Periodically persists [primaryCache] into [secondaryCache].
  /// 
  /// Recommended implementation for [primaryCache] - [DsClientMemoryCache], for [secondaryCache] - [DsClientFileCache].
  /// 
  /// [cachingTimeout] - the timeout of timer that triggers caching into [secondaryCache].
  /// Timer resets by adding into [primaryCache] after exceedance of [cachingTimeout].
  /// I.e. if state constantly changing in [primaryCache],
  /// then [cachingTimeout] is essentially the period of caching.
  /// 
  /// [secondaryCache] - the file in which the cache is saved and from which the cache is read.
  DsClientDelayedCache({
    required DsClientCache primaryCache, 
    DsClientCache secondaryCache = const DsClientFileCache(),
    Duration cachingTimeout = const Duration(seconds: 5),
  }) : 
    _primaryCache = primaryCache, 
    _secondaryCache = secondaryCache,
    _cachingTimeout = cachingTimeout;
   //
  @override
  Future<DsDataPoint?> get(String pointName) => _primaryCache.get(pointName);
  //
  @override
  Future<List<DsDataPoint>> getAll() => _primaryCache.getAll();
  //
  @override
  Future<void> add(DsDataPoint point) async {
    await _primaryCache.add(point);
    _persistToSecondaryDelayed();
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    await _primaryCache.addMany(points);
    _persistToSecondaryDelayed();
  }
  ///
  void _persistToSecondaryDelayed() {
    if(!(_timer?.isActive ?? false)) {
      _timer = Timer(_cachingTimeout, _persistToSecondary);
    }
  }
  ///
  Future<void> _persistToSecondary() async {
    final points = await _primaryCache.getAll();
    return _secondaryCache.addMany(points);
  }
}