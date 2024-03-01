import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'ds_client_cache.dart';
import 'ds_client_cache_file.dart';

/// 
/// Periodically persists cache states. 
final class DsClientScheduledPersistance {
  final DsClientCache _cache;
  final DsClientCacheFile _cacheFile;
  final Duration _cachingTimeout;
  Timer? _timer;
  /// 
  /// Periodically persists [cache] states.
  /// 
  /// [cachingTimeout] - the timeout of timer that triggers caching.
  /// Timer resets when state changes in [cache] after exceedance of [cachingTimeout].
  /// I.e. if state constantly changing in [cache],
  /// then [cachingTimeout] is essentially the period of caching.
  /// 
  /// [cacheFile] - the file in which the cache is saved and from which the cache is read.
  DsClientScheduledPersistance({
    required DsClientCache cache, 
    DsClientCacheFile cacheFile = const DsClientCacheFile(
      TextFile.path('./cache/points.json'),
    ),
    Duration cachingTimeout = const Duration(seconds: 5),
  }) : 
    _cache = cache, 
    _cacheFile = cacheFile,
    _cachingTimeout = cachingTimeout;
  ///
  /// Start listening cache changes.
  Future<void> start() async {
    _cache.addListener(_saveCacheDelayed);
    await _cache.start();
  }
  ///
  /// Stop listening cache changes.
  Future<void> stop() async {
    await _cache.stop();
    _timer?.cancel();
    _cache.removeListener(_saveCacheDelayed);
    await _saveCache();
  }
  ///
  void _saveCacheDelayed() {
    if(!(_timer?.isActive ?? false)) {
      _timer = Timer(_cachingTimeout, _saveCache);
    }
  }
  ///
  Future<void> _saveCache() {
    return _cacheFile.write(_cache.points);
  }
}