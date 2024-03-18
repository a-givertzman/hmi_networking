import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import '../ds_send/common/fake_ds_client.dart';

void main() {
  group('JdsServie .points()', () {
    test('with empty config response', () async {
      final jdsService = JdsService(
        dsClient: FakeDsClient(
          streams: {
            'Points': Stream<DsDataPoint<String>>.value(
              DsDataPoint<String>(
                type: DsDataType.string,
                name: DsPointName('/App/Jds/Points'),
                value: '{}',
                status: DsStatus.ok,
                timestamp: DsTimeStamp.now().toString(),
                cot: DsCot.reqCon,
              ),
            ), 
          },
        ),
      );
      final result = await jdsService.points();
      expect(result, isA<Ok>(), reason: 'Result should contain data');
      expect(
        (result as Ok<JdsPointConfigs, Failure>).value.toMap(),
        equals({}),
        reason: 'Result data should be empty config map',
      );
    });
    test('with filled config response', () async {
      const testConfigString = '''    {
              "Point.Name.0":{"address":{"bit":0,"offset":0},"alarm":0,"comment":"Test Point Bool","filters":{"threshold":5.0},"type":"Bool"},
              "Point.Name.1":{"address":{"bit":0,"offset":0},"alarm":0,"comment":"Test Point Bool","filters":{"factor":0.1,"threshold":5.0},"type":"Bool"},
              "PointName1":{"address":{"offset":0},"comment":"Test Point","history":"r","type":"Int"},
              "PointName2":{"address":{"offset":0},"alarm":4,"comment":"Test Point","type":"Int"},
              "PointName3":{"address":{"offset":12},"comment":"Test Point","history":"w","type":"Int"},
              "PointName4":{"address":{"offset":12},"comment":"Test Point","history":"rw","type":"Int"}
          }
      ''';
      const testConfig = {
        'Point.Name.0': {
          'address': {'bit': 0, 'offset': 0},
          'alarm': 0,
          'comment': 'Test Point Bool',
          'filters': {'threshold': 5.0},
          'type': 'bool',
        },
        'Point.Name.1': {
          'address': {'bit': 0, 'offset': 0},
          'alarm': 0,
          'comment': 'Test Point Bool',
          'filters': {'factor': 0.1,'threshold': 5.0},
          'type': 'bool',
        },
        'PointName1': {
          'address': {'offset': 0},
          'history': 'r',
          'comment': 'Test Point',
          'type': 'int',
        },
        'PointName2': {
          'address': {'offset': 0},
          'alarm': 4,
          'comment': 'Test Point',
          'type': 'int',
        },
        'PointName3': {
          'address': {'offset': 12},
          'history': 'w',
          'comment': 'Test Point',
          'type': 'int',
        },
        'PointName4': {
          'address': {'offset': 12},
          'history': 'rw',
          'comment': 'Test Point',
          'type': 'int',
        },
      }; 
      final jdsService = JdsService(
        dsClient: FakeDsClient(
          streams: {
            'Points': Stream<DsDataPoint<String>>.value(
              DsDataPoint<String>(
                type: DsDataType.string,
                name: DsPointName('/App/Jds/Points'),
                value: testConfigString,
                status: DsStatus.ok,
                timestamp: DsTimeStamp.now().toString(),
                cot: DsCot.reqCon,
              ),
            ), 
          },
        ),
      );
      final result = await jdsService.points();
      expect(result, isA<Ok>(), reason: 'Result should contain data');
      expect(
        (result as Ok<JdsPointConfigs, Failure>).value.toMap(),
        equals(testConfig),
        reason: 'Result data should be empty config map',
      );
    });
  });
}