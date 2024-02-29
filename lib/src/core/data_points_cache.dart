import 'dart:async';
import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
/// 
/// Persists latest values of each unique point from provided stream.
final class DataPointsCache {
  final Stream<DsDataPoint> _incomingPoints;
  final Duration _cachingTimeout;
  final TextFile _cacheFile;
  final Map<String, DsDataPoint> _cache = {};
  StreamSubscription<DsDataPoint>? _subscription;
  Timer? _timer;
  /// 
  /// Persists latest values of each unique point from [incomingPoints].
  /// 
  /// [cachingTimeout] - the timeout of timer that triggers caching.
  /// Timer resets when [cachingTimeout] exceeded and new point received from [incomingPoints].
  /// I.e. if points constantly firing from stream of [incomingPoints],
  /// then [cachingTimeout] is essentially the period of caching.
  /// 
  /// [cacheFile] - the file in which the cache is saved and from which the cache is read.
  DataPointsCache({
    required Stream<DsDataPoint> incomingPoints,
    Duration cachingTimeout = const Duration(seconds: 5),
    TextFile cacheFile = const TextFile.path('./cache/points.json'),
  }) : 
    _incomingPoints = incomingPoints,
    _cacheFile = cacheFile,
    _cachingTimeout = cachingTimeout;
  ///
  Iterable<DsDataPoint> get cachedPoints => _cache.values;
  ///
  /// Start listening the stream of incoming points.
  Future<void> start() async {
    final isNotListeting = _subscription == null || (_subscription?.isPaused ?? true);
    if(isNotListeting) {
      await _readCache();
      _subscription = _incomingPoints.listen((point) {
        _cache[point.name.name] = point;
        if(!(_timer?.isActive ?? false)) {
          _timer = Timer(_cachingTimeout, _saveCache);
        }
      }); 
    }
    
  }
  ///
  /// Stop listening the stream of incoming points.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _timer?.cancel();
    await _saveCache();
  }
  ///
  Future<void> _saveCache() {
    final serializedCache = json.encode(
      _cache.map((key, value) => MapEntry(
        key, 
        {
          'type': value.type.value,
          'name': value.name.toString(),
          'value': value.value,
          'status': value.status.value,
          'history': value.history,
          'alarm': value.alarm,
          'timestamp': value.timestamp,
        },
      )),
    );
    return _cacheFile.write(serializedCache);
  }
  ///
  Future<void> _readCache() async {
    final deserializedCache = await JsonMap.fromTextFile(_cacheFile)
      .decoded
      .then(
        (points) => points.map(
          (key, point) => MapEntry(
            key, 
            DsDataPoint(
              type: DsDataType.fromString(point['type']),
              name: DsPointName(point['name']),
              value: point['value'],
              status: DsStatus.fromValue(point['status']),
              history: point['history'],
              alarm: point['alarm'],
              timestamp: point['timestamp'],
            ),
          ),
        ),
      );
    _cache.addAll(deserializedCache);
  }
}