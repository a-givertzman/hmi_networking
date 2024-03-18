import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_cache_file.dart';
import 'fake_text_file.dart';

void main() {
  Log.initialize();
  group('DsCacheFile', () {
    test('write(cache) serializes maps properly', () async {
      final initialCaches = [
        {
          'cache': const <String, DsDataPoint>{},
          'file_content': '{}',
        },
        {
          'cache': {
            '': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:25:29.228612", cot: DsCot.inf),
          },
          'file_content': '{"":{"type":"bool","name":"/","value":"0","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:25:29.228612"}}',
        },
        {
          'cache': {
            'abc': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:27:53.149811", cot: DsCot.inf),
            '123': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/'), value: true, status: DsStatus.ok, timestamp: "2024-03-04T19:28:18.812448", cot: DsCot.inf),
          },
          'file_content': '{"abc":{"type":"bool","name":"/","value":"0","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:27:53.149811"},"123":{"type":"bool","name":"/","value":"1","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:28:18.812448"}}',
        },
        {
          'cache': {
            'point1': DsDataPoint<double>(type: DsDataType.real, name: DsPointName('/test/point1'), value: 474.20942, status: DsStatus.ok, timestamp: "2024-03-04T19:28:42.201794", cot: DsCot.inf),
            'point2': DsDataPoint<int>(type: DsDataType.integer, name: DsPointName('/test/point2'), value: 342134, status: DsStatus.ok, timestamp: "2024-03-04T19:28:58.117634", cot: DsCot.inf),
            'point3': DsDataPoint<bool>(type: DsDataType.bool, name: DsPointName('/test/point3'), value: false, status: DsStatus.ok, timestamp: "2024-03-04T19:29:20.274314", cot: DsCot.inf), 
          },
          'file_content': '{"point1":{"type":"real","name":"/test/point1","value":"474.20942","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:28:42.201794"},"point2":{"type":"int","name":"/test/point2","value":"342134","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:28:58.117634"},"point3":{"type":"bool","name":"/test/point3","value":"0","status":0,"alarm":0,"history":0,"cot":"Inf","timestamp":"2024-03-04T19:29:20.274314"}}',
        },
      ];
      for(final initialCache in initialCaches) {
        final cacheMap = initialCache['cache'] as Map<String, DsDataPoint>;
        final fileContent = initialCache['file_content'] as String;
        final textFile = FakeTextFile();
        final cacheFile = DsCacheFile(
          textFile,
        );
        await cacheFile.write(cacheMap);
        expect(textFile.contentText, equals(fileContent));
      }
    });
  });
}