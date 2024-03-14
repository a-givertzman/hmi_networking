import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_cot.dart';

void main() {
  group('JdsCot', () {
    const correctStringsData = [
      {
        'string': 'Inf',
        'value': JdsCot.inf,
      },
      {
        'string': 'Act',
        'value': JdsCot.act,
      },
      {
        'string': 'ActCon',
        'value': JdsCot.actCon,
      },
      {
        'string': 'ActErr',
        'value': JdsCot.actErr,
      },
      {
        'string': 'Req',
        'value': JdsCot.req,
      },
      {
        'string': 'ReqCon',
        'value': JdsCot.reqCon,
      },
      {
        'string': 'ReqErr',
        'value': JdsCot.reqErr,
      },
    ];
    test('.fromString(cot) deserializes correct strings properly', () async {
      for(final entry in correctStringsData) {
        final string = entry['string'] as String;
        final value = entry['value'] as JdsCot;
        expect(JdsCot.fromString(string), equals(value));
      }
    });
    test('.toString() serializes correctly', () async {
      for(final entry in correctStringsData) {
        final string = entry['string'] as String;
        final value = entry['value'] as JdsCot;
        expect(value.toString(), equals(string));
      }
    });
    test('.fromString(cot) throws on incorrect strings', () async {
      const incorrectStrings = ['asd', 'sdg',  '', 'dfghhfd', '34j5ls', 'a', 'i', 'r'];
      for(final string in incorrectStrings) {
        expect(() => JdsCot.fromString(string), throwsA(isA<ArgumentError>()));
      }
    });
  });
}