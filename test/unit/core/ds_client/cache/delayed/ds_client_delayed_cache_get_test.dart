import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/delayed/ds_client_delayed_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

import 'fake_ds_client_cache.dart';

void main() {
  group('DsClientDelayedCache', () {
    test('getAll() returns no points if no initial cache provided', () async {
      final cache = DsClientDelayedCache(
        memoryCache: FakeDsClientCache(),
        fileCache:  FakeDsClientCache(),
      );
      expect(await cache.getAll(), equals(const <DsDataPoint>[]));
    });
    test('get(pointName) returns null if no initial cache provided', () async {
      final testPointNames = ['Winch2.EncoderBR1', 'ConstantTension.Active', 'HPA.LowNiroPressure', 'HPU.HighPressure', 'Winch1.Overload'];
      final cache = DsClientDelayedCache(
        memoryCache: FakeDsClientCache(),
        fileCache:  FakeDsClientCache(),
      );
      for(final pointName in testPointNames) {
        expect(await cache.get(pointName), isNull);
      }
    });
    final initialCaches = [
      {
        '': DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
      },
      {
        'abc': DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        '123': DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
      },
      {
        'point1': DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        'point2': DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        'point3': DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()), 
      },
    ];
    test('getAll() returns provided initial cache', () async {
      for(final initialCache in initialCaches) {
        final cache = DsClientDelayedCache(
        memoryCache: FakeDsClientCache(initialCache),
        fileCache:  FakeDsClientCache(initialCache),
      );
        expect(await cache.getAll(), initialCache.values.toList());
      }
    });
    test('get(pointName) returns provided initial cache', () async {
      for(final initialCache in initialCaches) {
        final cacheEntries = initialCache.entries.toList();
        final cache = DsClientMemoryCache(initialCache: initialCache);
        for(var i=0; i<cacheEntries.length; i++) {
          final pointName = cacheEntries[i].key;
          final point = cacheEntries[i].value;
          expect(await cache.get(pointName), point);
        }
      }
    });
  });
}