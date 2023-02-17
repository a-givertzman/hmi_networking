import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_networking/src/core/ds_send.dart';
import 'fake_ds_client.dart';

void main() {
  group('DsSend constructor', () {
    test('asserts if unsupported type was provided', () {
      expect(
        () => DsSend<String>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
        ), 
        throwsA(isA<AssertionError>()),
        reason: 'DsSend constructor didn`t assert on unsupported type',
      );
      expect(
        () => DsSend<DateTime>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
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
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
      expect(
        () => DsSend<int>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
      expect(
        () => DsSend<double>(
          dsClient: FakeDsClient(),
          pointName: DsPointName('/'),
        ), 
        returnsNormally,
        reason: 'DsSend constructor asserted on supported type',
      );
    });
  });
}