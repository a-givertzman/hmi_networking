import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'fake_ds_client.dart';
import 'test_point_paths.dart';
import 'test_streams.dart';
//
void main() {
  group('DsSend exec', () {
    final dsClient = FakeDsClient(streams: testStreams);
    test('with response executes all supported types', () async {
      final sendIntResult = await DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
        response: 'stream_int',
      ).exec(123);
      expect(sendIntResult.value, 1);
      //
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointPath: pointPaths[bool]!,
        response: 'stream_bool',
      ).exec(true);
      expect(sendBoolResult.value, true);
      //
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointPath: pointPaths[double]!,
        response: 'stream_real',
      ).exec(0.5);
      expect(sendRealResult.value, 1.234);
    });
    //
    test('without response executes all supported types', () async {
      final sendIntResult = await DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
      ).exec(123);
      expect(sendIntResult.value, 2);
      //
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointPath: pointPaths[bool]!,
      ).exec(true);
      expect(sendBoolResult.value, false);
      //
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointPath: pointPaths[double]!,
      ).exec(0.5);
      expect(sendRealResult.value, 2.345);
    });
  });
}