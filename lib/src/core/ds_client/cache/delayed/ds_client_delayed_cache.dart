import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_file_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

/// 
/// Periodically persists memory cache into file. 
final class DsClientDelayedCache implements DsClientCache {
  final DsClientMemoryCache _memoryCache;
  final DsClientFileCache _fileCache;
  final Duration _cachingTimeout;
  Timer? _timer;
  /// 
  /// Periodically persists [memoryCache] into [fileCache].
  /// 
  /// [cachingTimeout] - the timeout of timer that triggers caching into [fileCache].
  /// Timer resets by adding into [memoryCache] after exceedance of [cachingTimeout].
  /// I.e. if state constantly changing in [memoryCache],
  /// then [cachingTimeout] is essentially the period of caching.
  /// 
  /// [fileCache] - the file in which the cache is saved and from which the cache is read.
  DsClientDelayedCache({
    required DsClientMemoryCache memoryCache, 
    DsClientFileCache fileCache = const DsClientFileCache(),
    Duration cachingTimeout = const Duration(seconds: 5),
  }) : 
    _memoryCache = memoryCache, 
    _fileCache = fileCache,
    _cachingTimeout = cachingTimeout;
  //
  @override
  Future<Map<String, DsDataPoint>> get points => _memoryCache.points;
  //
  @override
  Future<void> add(DsDataPoint point) async {
    await _memoryCache.add(point);
    _saveCacheDelayed();
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    await _memoryCache.addMany(points);
    _saveCacheDelayed();
  }
  ///
  void _saveCacheDelayed() {
    if(!(_timer?.isActive ?? false)) {
      _timer = Timer(_cachingTimeout, _saveCache);
    }
  }
  ///
  Future<void> _saveCache() async {
    final points = await _memoryCache.points;
    return _fileCache.addMany(points.values);
  }
}