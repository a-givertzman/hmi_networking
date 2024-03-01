import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hmi_core/hmi_core.dart';

/// 
/// Remembers latest values of each unique point from provided stream.
final class DsClientCache with ChangeNotifier {
  final Stream<DsDataPoint> _incomingPoints;
  final Map<String, DsDataPoint> _cache = {};
  StreamSubscription<DsDataPoint>? _subscription;
  /// 
  /// Remembers latest values of each unique point from [incomingPoints].
  DsClientCache({
    Map<String, DsDataPoint> initialCache = const {},
    required Stream<DsDataPoint> incomingPoints,
  }) : 
    _incomingPoints = incomingPoints {
      _cache.addAll(initialCache);
    }
  ///
  /// Collection of all currently saved points.
  Map<String, DsDataPoint> get points => Map.unmodifiable(_cache);
  ///
  /// Start listening the stream of incoming points.
  Future<void> start() async {
    final isNotListeting = _subscription == null || (_subscription?.isPaused ?? true);
    if(isNotListeting) {
      _subscription = _incomingPoints.listen((point) {
        _cache[point.name.name] = point;
        notifyListeners();
      }); 
    }
  }
  ///
  /// Stop listening the stream of incoming points.
  Future<void> stop() async {
    await _subscription?.cancel();
  }
}