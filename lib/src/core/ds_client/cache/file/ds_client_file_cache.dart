import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_cache_text_file.dart';

/// Remembers latest values of each unique point in json file.
final class DsClientFileCache implements DsClientCache {
  final DsClientCacheTextFile _cacheFile;
  /// Remembers latest values of each unique point in [cacheFile] in json format.
  const DsClientFileCache({
    DsClientCacheTextFile cacheFile = const DsClientCacheTextFile(
      TextFile.path('./cache/points.json'),
    ),
  }) : _cacheFile = cacheFile;
  //
  @override
  Future<DsDataPoint?> get(String pointName) {
    return _cacheFile.read().then(
      (points) => points[pointName],
    );
  }
  //
  @override
  Future<List<DsDataPoint>> getAll() {
    return _cacheFile.read().then(
      (points) => points.values.toList(),
    );
  }
  //
  @override
  Future<void> add(DsDataPoint point) async {
    final cache = await _cacheFile.read();
    cache[point.name.name] = point;
    return _cacheFile.write(cache);
  }
  //
  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    final cache = await _cacheFile.read();
    cache.addEntries(
      points.map(
        (point) => MapEntry(point.name.name, point),
      ),
    );
    return _cacheFile.write(cache);
  }
}