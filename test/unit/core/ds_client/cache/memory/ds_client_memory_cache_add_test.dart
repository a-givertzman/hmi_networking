import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

void main() {
  group('DsClientMemoryCache', () {
    test('add(point) inserts point to its internal state', () async {
      final testPoints = [
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()), 
      ];
      final cache = DsClientMemoryCache();
      for(final point in testPoints) {
        await cache.add(point);
        expect(await cache.get(point.name.name), equals(point));
      }
    });
    test('addMany(points) inserts multiple points to its internal state', () async {
      final testPointBatches = [
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point2'), value: true, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.timeInvalid, timestamp: DsTimeStamp.now().toString()),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point2'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point3'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point5'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),  
        ],
        [
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point5'), value: 474.20942, status: DsStatus.obsolete, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point6'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point7'), value: false, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString()), 
        ],
      ];
      for(final batch in testPointBatches) {
        final cache = DsClientMemoryCache();
        await cache.addMany(batch);
        expect(await cache.getAll(), equals(batch));
      }
    });
    test('add(point) updates point in its internal state', () async {
      final uniqueTestPoints = [
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612"),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: true, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228612"),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228612"),
        DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612"),
        DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point1'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612"),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228612"), 
      ];
      const pointName = 'point1';
      final cache = DsClientMemoryCache();
      DsDataPoint oldPoint = uniqueTestPoints[0];
      await cache.add(oldPoint);
      for(final point in uniqueTestPoints.sublist(1)) {
        expect(
          await cache.get(pointName), equals(oldPoint), 
          reason: 'Should be equal to old value before an addition.',
        );
        final newPoint = point;
        expect(
          newPoint, isNot(equals(oldPoint)),
          reason: 'Points should have different attributes in this test.',
        );
        await cache.add(newPoint);
        expect(
          await cache.get(pointName), equals(newPoint), 
          reason: 'Should be equal to new value after an addition.',
        );
        oldPoint = newPoint;
      }
    });
    test('addMany(points) updates multiple point in its internal state', () async {
      final uniquePointsBatches = [
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228611"),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point2'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612"),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point3'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228613"),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228614"),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228615"),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228616"),
        ],
        [
          DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point1'), value: false, status: DsStatus.timeInvalid, timestamp: "2024-03-04T19:25:29.228617"),
          DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point2'), value: 474.20942, status: DsStatus.obsolete, timestamp: "2024-03-04T19:25:29.228618"),
          DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point3'), value: 342134, status: DsStatus.invalid, timestamp: "2024-03-04T19:25:29.228619"),
        ],
      ];
      final cache = DsClientMemoryCache();
      // Using JdsDataPoint to easily copy DsDataPoint objects.
      List<DsDataPoint> oldPoints = uniquePointsBatches[0];
      await cache.addMany(oldPoints);
      for(final pointsBatch in uniquePointsBatches.sublist(1)) {
        expect(
          await cache.getAll(), containsAll(oldPoints), 
          reason: 'Should be equal to old values before an addition.',
        );
        final newPoints = pointsBatch;
        expect(
          newPoints, isNot(containsAll(oldPoints)),
          reason: 'Points batches should have different attributes in this test.',
        );
        await cache.addMany(newPoints);
        expect(
          await cache.getAll(), containsAll(newPoints), 
          reason: 'Should be equal to new values after an addition.',
        );
        oldPoints = newPoints;
      }
    });
  });
}