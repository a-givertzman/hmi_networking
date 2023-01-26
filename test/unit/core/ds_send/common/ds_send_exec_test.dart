import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'fake_ds_client.dart';
import 'test_point_paths.dart';
import 'test_streams.dart';
//
void main() {
  const _debug = true;
  group('DsSend exec', () {
    const timeout = 10;
    final dsClient = FakeDsClient(streams: testStreams);

    test('with response and valid timeout', () async {
      final sendIntResult = DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
        response: 'stream_int_valid_timeout',
      ).exec(123);
      await sendIntResult
        .then((responsePoint) {
          log(_debug, 'responsePoint: $responsePoint');
          expect(responsePoint.hasData, true, reason: 'Result should contains data');
          expect(responsePoint.data.value, 121, reason: 'Result data should be 121');
        })
        .timeout(Duration(seconds: timeout), onTimeout: () {
          expect(false, true, reason: 'Response timeout ($timeout sec) exceeded!');
        });
    });

    test('with response and exceeded timeout', () async {
      log(_debug, 'time out will be exceeded...');
      final sendIntResult = DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
        response: 'stream_int_exceeded_timeout',
      ).exec(123);
      await sendIntResult
        .then((responsePoint) {
          expect(responsePoint.hasData, false, reason: 'Result should contains data');
          expect(responsePoint.hasError, true, reason: 'Result should contains Error');
        })
        .timeout(Duration(seconds: timeout), onTimeout: () {
          expect(false, true, reason: 'Response timeout ($timeout sec) exceeded!');
        });
    });

    test('with response executes all supported types', () async {
      final sendIntResult = DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
        response: 'stream_int',
      ).exec(123);
      await sendIntResult.then((responsePoint) {
        expect(responsePoint.data.value, 1);
      });
      //
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointPath: pointPaths[bool]!,
        response: 'stream_bool',
      ).exec(true);
      expect(sendBoolResult.data.value, true);
      //
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointPath: pointPaths[double]!,
        response: 'stream_real',
      ).exec(0.5);
      expect(sendRealResult.data.value, 1.234);
    });
    //
    test('without response executes all supported types', () async {
      final sendIntResult = await DsSend<int>(
        dsClient: dsClient,
        pointPath: pointPaths[int]!,
      ).exec(123);
      expect(sendIntResult.data.value, 2);
      //
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointPath: pointPaths[bool]!,
      ).exec(true);
      expect(sendBoolResult.data.value, false);
      //
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointPath: pointPaths[double]!,
      ).exec(0.5);
      expect(sendRealResult.data.value, 2.345);
    });
  });
}