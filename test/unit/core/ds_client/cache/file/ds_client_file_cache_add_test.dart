import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_file_cache.dart';

import 'fake_ds_cache_file.dart';

void main() {
  group('DsClientFileCache', () {
    test('add(point) inserts point to file', () async {
      final testPoints = [
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/a'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/b'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/c'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf), 
      ];
      final fakeFile = FakeDsCacheFile();
      final cache = DsClientFileCache(
        cacheFile: fakeFile,
      );
      for(final point in testPoints) {
        await cache.add(point);
        expect(fakeFile.internalMap[point.name.toString()], equals(point));
      }
    });
    test('addMany(points) inserts multiple points to file', () async {
      final testPointBatches = [
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point2'), value: true, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.timeInvalid, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point2'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point3'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point5'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),  
        ],
        [
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point5'), value: 474.20942, status: DsStatus.obsolete, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point6'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point7'), value: false, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf), 
        ],
      ];
      for(final batch in testPointBatches) {
        final fakeFile = FakeDsCacheFile();
        final cache = DsClientFileCache(
          cacheFile: fakeFile,
        );
        await cache.addMany(batch);
        expect(fakeFile.internalMap.values, equals(batch));
      }
    });
    test('add(point) updates point inside file', () async {
      final uniqueTestPoints = [
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: true, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
        DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
        DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point1'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf), 
      ];
      const pointName = '/test/point1';
      final fakeFile = FakeDsCacheFile();
      final cache = DsClientFileCache(
        cacheFile: fakeFile,
      );
      DsDataPoint oldPoint = uniqueTestPoints[0];
      await cache.add(oldPoint);
      for(final point in uniqueTestPoints.sublist(1)) {
        expect(
          fakeFile.internalMap[pointName], equals(oldPoint), 
          reason: 'Should be equal to old value before an addition. Internal map: ${fakeFile.internalMap}',
        );
        final newPoint = point;
        expect(
          newPoint, isNot(equals(oldPoint)),
          reason: 'Points should have different attributes in this test. Internal map: ${fakeFile.internalMap}',
        );
        await cache.add(newPoint);
        expect(
          fakeFile.internalMap[pointName], equals(newPoint), 
          reason: 'Should be equal to new value after an addition. Internal map: ${fakeFile.internalMap}',
        );
        oldPoint = newPoint;
      }
    });
    test('addMany(points) updates multiple point inside file', () async {
      final uniquePointsBatches = [
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228611", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point2'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point3'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228613", cot: DsCot.inf),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228614", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228615", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228616", cot: DsCot.inf),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228617", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point2'), value: 474.20942, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228618", cot: DsCot.inf),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point3'), value: 342134, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228619", cot: DsCot.inf),
        ],
      ];
      final fakeFile = FakeDsCacheFile();
      final cache = DsClientFileCache(
        cacheFile: fakeFile,
      );
      // Using JdsDataPoint to easily copy DsDataPoint objects.
      List<DsDataPoint> oldPoints = uniquePointsBatches[0];
      await cache.addMany(oldPoints);
      for(final pointsBatch in uniquePointsBatches.sublist(1)) {
        expect(
          fakeFile.internalMap.values.toList(), containsAll(oldPoints), 
          reason: 'Should be equal to old values before an addition.',
        );
        final newPoints = pointsBatch;
        expect(
          newPoints, everyElement(isNot(isIn(oldPoints))),
          reason: 'Points batches should have different attributes in this test.',
        );
        await cache.addMany(newPoints);
        expect(
          fakeFile.internalMap.values.toList(), containsAll(newPoints), 
          reason: 'Should be equal to new values after an addition.',
        );
        oldPoints = newPoints;
      }
    });
  });
}