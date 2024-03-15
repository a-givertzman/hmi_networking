import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_file_cache.dart';
import 'fake_ds_cache_file.dart';

void main() {
  Log.initialize();
  group('DsClientFileCache', () {
    test('getAll() returns no points if file doesn\'t exist', () async {
      final cache = DsClientFileCache(
        cacheFile: FakeDsCacheFile(),
      );
      expect(await cache.getAll(), equals(const <DsDataPoint>[]));
    });
    test('get(pointName) returns no points if file doesn\'t exist', () async {
      final testPointNames = ['Winch2.EncoderBR1', 'ConstantTension.Active', 'HPA.LowNiroPressure', 'HPU.HighPressure', 'Winch1.Overload'];
      final cache = DsClientFileCache(
        cacheFile: FakeDsCacheFile(),
      );
      for(final pointName in testPointNames) {
        expect(await cache.get(pointName), isA<None>());
      }
    });
    final initialCaches = [
      {
        '': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
      },
      {
        'abc': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:27:53.149811", cot: DsCot.inf),
        '123': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: true, status: DsStatus.ok, timestamp: "2024-03-04T19:28:18.812448", cot: DsCot.inf),
      },
      {
        'point1': DsDataPoint<double>(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:28:42.201794", cot: DsCot.inf),
        'point2': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:28:58.117634", cot: DsCot.inf),
        'point3': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:29:20.274314", cot: DsCot.inf), 
      },
    ];
    test('getAll() returns initial cache from existing file', () async {
      for(final initialCache in initialCaches) {
        final targetPoints = initialCache.values.toList();
        final cache = DsClientFileCache(
          cacheFile: FakeDsCacheFile(initialCache),
        );
        final receivedPoints = await cache.getAll();
        expect(receivedPoints, equals(targetPoints));
      }
    });
    test('get(pointName) returns initial cache point from existing file', () async {
      for(final initialCache in initialCaches) {
        final cacheEntries = initialCache.entries.toList();
        final cache = DsClientFileCache(
          cacheFile: FakeDsCacheFile(initialCache),
        );
        for(var i=0; i<cacheEntries.length; i++) {
          final pointName = cacheEntries[i].key;
          final point = cacheEntries[i].value;
          final option = await cache.get(pointName);
          expect(option, isA<Some>());
          final receivedPoint = (option as Some<DsDataPoint>).value;
          expect(receivedPoint, equals(point));
        }
      }
    });
  });
}