import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/entities/data_object.dart';

import 'fake_data_set.dart';

void main() {
  group('DataObject asMap()', () {
    test('returns underlying Map', () {
      const mapData =  [
        {
          'provided': [MapEntry('test1key', ValueString('test1value')), MapEntry('test1key', ValueString('test1value')), MapEntry('test1key', ValueString('test1value'))],
          'expected': {'test1key': ValueString('test1value')},
        },
        {
          'provided': [MapEntry('test1key', ValueString('test1value')), MapEntry('test2key', ValueString('test2value'))],
          'expected': {'test1key': ValueString('test1value'), 'test2key': ValueString('test2value')},
        },
        {
          'provided': [MapEntry('test1key', ValueString('test1value')), MapEntry('test3key', ValueString('test3value'))],
          'expected': {'test1key': ValueString('test1value'), 'test3key': ValueString('test3value')},
        },
        {
          'provided': [MapEntry('test1key', ValueString('test1value')), MapEntry('test2key', ValueString('test2value')), MapEntry('test3key', ValueString('test3value'))],
          'expected': {'test1key': ValueString('test1value'), 'test2key': ValueString('test2value'), 'test3key': ValueString('test3value')},
        },
        {
          'provided': [],
          'expected': {},
        },
      ];
      for(final entry in mapData) {
        final dataObject = DataObject(remote: const FakeDataSet());
        final provided = (entry['provided'] as List).cast<MapEntry<String, ValueObject<String>>>();
        final expected = entry['expected'] as Map;
        for(final row in provided) {
          dataObject[row.key] = row.value;
        }
        expect(dataObject.asMap(), equals(expected));
      }
    });
  });
}