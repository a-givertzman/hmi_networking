import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_cache_text_file.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_client_file_cache.dart';
import 'package:hmi_networking/src/core/ds_client/cache/memory/ds_client_memory_cache.dart';

void main() {
  group('DsClientFileCache constructor', () {
    const filePath = './test/cache.json';
    late File testFile;
    setUp(() {
      testFile = File(filePath);
      if(testFile.existsSync()) {
        testFile.deleteSync();
      }
    });
    tearDown(() {
      testFile.deleteSync();
    });
    test('creates cache with no points if file doesn\'t exist', () async {
      const cache = DsClientFileCache(
        cacheFile: DsClientCacheTextFile(TextFile.path(filePath)),
      );
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