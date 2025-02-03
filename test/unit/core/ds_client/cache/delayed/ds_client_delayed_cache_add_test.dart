import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/delayed/ds_client_delayed_cache.dart';

import 'fake_ds_client_cache.dart';

void main() {
  Log.initialize();
  group('DsClientDelayedCache', () {
    const delayFactor = 1.5;
    test('add(point) inserts point into primary cache first and into secondary after delay', () async {
      final testPoints = [
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/a'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/b'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/c'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
        DsDataPoint(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf), 
      ];
      const delay = Duration(milliseconds: 50);
      final fakePrimaryCache = FakeDsClientCache();
      final fakeSecondaryCache = FakeDsClientCache();
      final cache = DsClientDelayedCache(
        primaryCache: fakePrimaryCache,
        secondaryCache: fakeSecondaryCache,
        cachingTimeout: delay,
      );
      for(final point in testPoints) {
        await cache.add(point);
        expect(
          fakePrimaryCache.internalMap[point.name.name], equals(point),
          reason: 'Primary cache sould be updated right after addition.',
        );
        expect(
          fakeSecondaryCache.internalMap[point.name.name], isNull,
          reason: 'Secondary cache souldn\'t be updated before delay.',
        );
        await Future.delayed(delay * delayFactor);
        expect(
          fakeSecondaryCache.internalMap[point.name.name], equals(point),
          reason: 'Secondary cache sould be updated after delay.',
        );
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
      const delay = Duration(milliseconds: 50);
      for(final batch in testPointBatches) {
        final fakePrimaryCache = FakeDsClientCache();
        final fakeSecondaryCache = FakeDsClientCache();
        final cache = DsClientDelayedCache(
          primaryCache: fakePrimaryCache,
          secondaryCache: fakeSecondaryCache,
          cachingTimeout: delay,
        );
        await cache.addMany(batch);
        expect(
          fakePrimaryCache.internalMap.values, equals(batch),
          reason: 'Primary cache sould be updated right after addition.',
        );
        expect(
          fakeSecondaryCache.internalMap.values, isEmpty,
          reason: 'Secondary cache souldn\'t be updated before delay.',
        );
        await Future.delayed(delay * delayFactor);
        expect(
          fakeSecondaryCache.internalMap.values, equals(batch),
          reason: 'Secondary cache sould be updated after delay.',
        );
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
      const pointName = 'point1';
      const delay = Duration(milliseconds: 50);
      final fakePrimaryCache = FakeDsClientCache();
      final fakeSecondaryCache = FakeDsClientCache();
      final cache = DsClientDelayedCache(
        primaryCache: fakePrimaryCache,
        secondaryCache: fakeSecondaryCache,
        cachingTimeout: delay,
      );
      DsDataPoint oldPoint = uniqueTestPoints[0];
      await cache.add(oldPoint);
      for(final point in uniqueTestPoints.sublist(1)) {
        expect(
          fakePrimaryCache.internalMap[pointName], equals(oldPoint), 
          reason: 'Should be equal to old value before an addition.',
        );
        final newPoint = point;
        expect(
          newPoint, isNot(equals(oldPoint)),
          reason: 'Points should have different attributes in this test.',
        );
        await cache.add(newPoint);
        expect(
          fakePrimaryCache.internalMap[pointName], equals(newPoint), 
          reason: 'Should be equal to new value after an addition.',
        );
        await Future.delayed(delay * delayFactor);
        expect(
          fakeSecondaryCache.internalMap[pointName], equals(newPoint), 
          reason: 'Should be equal to new value after an addition after a delay.',
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
      const delay = Duration(milliseconds: 50);
      final fakePrimaryCache = FakeDsClientCache();
      final fakeSecondaryCache = FakeDsClientCache();
      final cache = DsClientDelayedCache(
        primaryCache: fakePrimaryCache,
        secondaryCache: fakeSecondaryCache,
        cachingTimeout: delay,
      );
      List<DsDataPoint> oldPoints = uniquePointsBatches[0];
      await cache.addMany(oldPoints);
      for(final pointsBatch in uniquePointsBatches.sublist(1)) {
        expect(
          fakePrimaryCache.internalMap.values.toList(), containsAll(oldPoints), 
          reason: 'Should be equal to old values before an addition.',
        );
        final newPoints = pointsBatch;
        expect(
          newPoints, everyElement(isNot(isIn(oldPoints))),
          reason: 'Points batches should have different attributes in this test.',
        );
        await cache.addMany(newPoints);
        expect(
          fakePrimaryCache.internalMap.values.toList(), containsAll(newPoints),
          reason: 'Should be equal to new values after an addition.',
        );
        await Future.delayed(delay * delayFactor);
        expect(
          fakeSecondaryCache.internalMap.values.toList(), containsAll(newPoints),
          reason: 'Should be equal to new values after an addition after a delay.',
        );
        oldPoints = newPoints;
      }
    });
  });
}