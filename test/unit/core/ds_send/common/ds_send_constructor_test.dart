import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'fake_ds_client.dart';

///
class _FakeType {}
///
void main() {
  group('DsSend constructor', () {
    test('asserts if unsupported type was provided', () {
      expect(
        () => DsSend<_FakeType>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
          cot: DsCot.act,
          responseCots: [DsCot.actCon, DsCot.actErr],
        ), 
        throwsA(isA<AssertionError>()),
        reason: 'DsSend constructor didn`t assert on unsupported type',
      );
      expect(
        () => DsSend<DateTime>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
          cot: DsCot.act,
          responseCots: [DsCot.actCon, DsCot.actErr],
        ), 
        throwsA(isA<AssertionError>()),
        reason: 'DsSend constructor didnt`t assert on unsupported type',
      );
    });
     test('completes normally if supported type was provided', () {
      expect(
        () => DsSend<bool>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
          cot: DsCot.act,
          responseCots: [DsCot.actCon, DsCot.actErr],
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
      expect(
        () => DsSend<int>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
          cot: DsCot.act,
          responseCots: [DsCot.actCon, DsCot.actErr],
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
      expect(
        () => DsSend<double>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
          cot: DsCot.act,
          responseCots: [DsCot.actCon, DsCot.actErr],
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
    });
  });
}