import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_cot.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_data_type.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_package.dart';

void main() {
  group('JdsPackage', () {
    // 2024-03-14 15:54:18.386663
    // 2024-03-14 15:54:01.100693
    // 2024-03-14 15:53:44.757341
    // 2024-03-14 15:53:17.333544
    // 2024-03-14 15:52:46.919226
    final correctStringsData = [
      {
        'map': {
          'type': 'Bool',
          'value': '1',
          'name': '/App/test1',
          'status': 0,
          'cot': 'Act',
          'timestamp': '2024-03-14 15:54:18.386663',
        },
        'value': JdsPackage(
          type: JdsDataType.boolean, 
          value: true, 
          name: DsPointName('/App/test1'), 
          status: DsStatus.ok, 
          cot: JdsCot.act, 
          timestamp: DateTime.parse('2024-03-14 15:54:18.386663'),
        ),
      },
      {
        'map': {
          'type': 'Int',
          'value': '4654323',
          'name': '/App/test2',
          'status': 2,
          'cot': 'Req',
          'timestamp': '2024-03-14 15:54:01.100693',
        },
        'value': JdsPackage(
          type: JdsDataType.integer, 
          value: 4654323, 
          name: DsPointName('/App/test2'), 
          status: DsStatus.obsolete, 
          cot: JdsCot.req, 
          timestamp: DateTime.parse('2024-03-14 15:54:01.100693'),
        ),
      },
      {
        'map': {
          'type': 'String',
          'value': 'abc123',
          'name': '/App/test3',
          'status': 10,
          'cot': 'Inf',
          'timestamp': '2024-03-14 15:53:44.757341',
        },
        'value': JdsPackage(
          type: JdsDataType.string, 
          value: 'abc123', 
          name: DsPointName('/App/test3'), 
          status: DsStatus.invalid, 
          cot: JdsCot.inf, 
          timestamp: DateTime.parse('2024-03-14 15:53:44.757341'),
        ),
      },
      {
        'map': {
          'type': 'Float',
          'value': '12.978',
          'name': '/App/test4',
          'status': 3,
          'cot': 'Inf',
          'timestamp': '2024-03-14 15:53:17.333544',
        },
        'value': JdsPackage(
          type: JdsDataType.float, 
          value: 12.978, 
          name: DsPointName('/App/test4'), 
          status: DsStatus.timeInvalid, 
          cot: JdsCot.inf, 
          timestamp: DateTime.parse('2024-03-14 15:53:17.333544'),
        ),
      },
    ];
    test('.fromMap(map) deserializes correct maps properly', () async {
      for(final entry in correctStringsData) {
        final map = entry['map'] as Map<String, dynamic>;
        final value = entry['value'] as JdsPackage;
        expect(JdsPackage.fromMap(map), equals(value));
      }
    });
    test('.toMap() serializes correctly', () async {
      for(final entry in correctStringsData) {
        final map = entry['map'] as Map<String, dynamic>;
        final value = entry['value'] as JdsPackage;
        expect(value.toMap(), equals(map));
      }
    });
  });
}