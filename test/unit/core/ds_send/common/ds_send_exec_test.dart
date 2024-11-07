import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'fake_ds_client.dart';
import 'test_point_paths.dart';
import 'test_streams.dart';
//
void main() {
  Log.initialize();
  const log = Log('DsSend .exec() test');
  group('DsSend exec', () {
    const timeout = 10;
    final dsClient = FakeDsClient(streams: testStreams);
    test('with response and valid timeout', () async {
      final sendIntResult = DsSend<int>(
        dsClient: dsClient,
        pointName: pointPaths[int]!,
        response: 'stream_int_valid_timeout',
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
      ).exec(123);
      await sendIntResult
        .then((responsePoint) {
          log.debug('responsePoint: $responsePoint');
          expect(responsePoint is Ok, true, reason: 'Result should contain data');
          expect((responsePoint as Ok<DsDataPoint<int>, Failure>).value.value, 121, reason: 'Result data should be 121');
        })
        .timeout(const Duration(seconds: timeout), onTimeout: () {
          expect(false, true, reason: 'Response timeout ($timeout sec) exceeded!');
        });
    });
    test('with response and exceeded timeout', () async {
      log.debug('time out will be exceeded...');
      final sendIntResult = DsSend<int>(
        dsClient: dsClient,
        pointName: pointPaths[int]!,
        cot: DsCot.req,
        responseCots: [DsCot.reqCon, DsCot.reqErr],
        response: 'stream_int_exceeded_timeout',
      ).exec(123);
      await sendIntResult
        .then((responsePoint) {
          expect(responsePoint is Ok, false, reason: 'Result should not contain data');
          expect(responsePoint is Err, true, reason: 'Result should contain Error');
        })
        .timeout(const Duration(seconds: timeout), onTimeout: () {
          expect(false, true, reason: 'Response timeout ($timeout sec) exceeded!');
        });
    });
    test('with response executes all supported types', () async {
      final sendIntResult = await DsSend<int>(
        dsClient: dsClient,
        pointName: pointPaths[int]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
        response: 'stream_int',
      ).exec(123);
      expect(sendIntResult is Ok, equals(true));
      expect((sendIntResult as Ok<DsDataPoint<int>, Failure>).value.value, 1);
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointName: pointPaths[bool]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
        response: 'stream_bool',
      ).exec(true);
      expect(sendBoolResult is Ok, equals(true));
      expect((sendBoolResult as Ok<DsDataPoint<bool>, Failure>).value.value, true);
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointName: pointPaths[double]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
        response: 'stream_real',
      ).exec(0.5);
      expect(sendRealResult is Ok, equals(true));
      expect((sendRealResult as Ok<DsDataPoint<double>, Failure>).value.value, 1.234);
    });
    test('without response executes all supported types', () async {
      final sendIntResult = await DsSend<int>(
        dsClient: dsClient,
        pointName: pointPaths[int]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
      ).exec(123);
      expect(sendIntResult is Ok, equals(true));
      expect((sendIntResult as Ok<DsDataPoint<int>, Failure>).value.value, 2);
      final sendBoolResult = await DsSend<bool>(
        dsClient: dsClient,
        pointName: pointPaths[bool]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
      ).exec(true);
      expect(sendBoolResult is Ok, equals(true));
      expect((sendBoolResult as Ok<DsDataPoint<bool>, Failure>).value.value, false);
      final sendRealResult = await DsSend<double>(
        dsClient: dsClient,
        pointName: pointPaths[double]!,
        cot: DsCot.act,
        responseCots: [DsCot.actCon, DsCot.actErr],
      ).exec(0.5);
      expect(sendRealResult is Ok, equals(true));
      expect((sendRealResult as Ok<DsDataPoint<double>, Failure>).value.value, 2.345);
    });
  });
}