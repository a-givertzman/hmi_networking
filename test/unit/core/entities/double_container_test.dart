import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';
//
void main() {
  group('DoubleContainer', () {
    final data = [
      {'v1': 102, 'v2': 'dfhst'},
      {'v1': -102, 'v2': '8w5ygrj'},
    ];
    test('create', () async {
      for (final input in data) {
        final dc = DoubleContainer<int, String>(
          value1: input['v1'] as int,
          value2: input['v2'] as String,
        );
        expect(dc.value1, input['v1'], reason: 'Values should be same');
        expect(dc.value2, input['v2'], reason: 'Values should be same');
      }
    });
  });
}