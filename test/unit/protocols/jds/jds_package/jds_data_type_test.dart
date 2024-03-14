import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_data_type.dart';

void main() {
  group('JdsDataType', () {
    const correctStringsData = [
      {
        'string': 'Bool',
        'value': JdsDataType.boolean,
      },
      {
        'string': 'Int',
        'value': JdsDataType.integer,
      },
      {
        'string': 'Float',
        'value': JdsDataType.float,
      },
      {
        'string': 'String',
        'value': JdsDataType.string,
      },
    ];
    test('.fromString(type) deserializes correct strings properly', () async {
      for(final entry in correctStringsData) {
        final string = entry['string'] as String;
        final value = entry['value'] as JdsDataType;
        expect(JdsDataType.fromString(string), equals(value));
      }
    });
    test('.toString() serializes correctly', () async {
      for(final entry in correctStringsData) {
        final string = entry['string'] as String;
        final value = entry['value'] as JdsDataType;
        expect(value.toString(), equals(string));
      }
    });
    test('.fromString(type) throws on incorrect strings', () async {
      const incorrectStrings = ['asd', 'sdg',  '', 'dfghhfd', '34j5ls', 'a', 'i', 'r'];
      for(final string in incorrectStrings) {
        expect(() => JdsDataType.fromString(string), throwsA(isA<ArgumentError>()));
      }
    });
  });
}