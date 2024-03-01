import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

void main() {
  group('DsClientMemoryCache constructor', () {
    test('doesn\'t add any points to the map', () async {
      final cache = DsClientMemoryCache();
      expect(await cache.getAll(), equals(const <String, DsDataPoint>{}));
    });
    test('sets provided initial cache', () async {
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
      for(final initialCache in initialCaches) {
        final cache = DsClientMemoryCache(initialCache: initialCache);
        expect(await cache.getAll(), initialCache);
      }
    });
  });
}