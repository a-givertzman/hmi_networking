import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import '../ds_send/common/fake_ds_client.dart';

void main() {
  group('JdsServie .subscribe(names)', () {
    test('with subscribtions list', () async {
      final jdsService = JdsService(
        dsClient: FakeDsClient(
          streams: {
            'Subscribe': Stream<DsDataPoint<String>>.value(
              DsDataPoint<String>(
                type: DsDataType.string,
                name: DsPointName('/App/Jds/Subscribe'),
                value: '',
                status: DsStatus.ok,
                timestamp: DsTimeStamp.now().toString(),
                cot: DsCot.reqCon,
              ),
            ), 
          },
        ),
      );
      final result = await jdsService.subscribe();
      expect(result, isA<Ok>(), reason: 'Result should contain data');
    });
    test('with filled subscribtions list', () async {
     final jdsService = JdsService(
        dsClient: FakeDsClient(
          streams: {
            'Subscribe': Stream<DsDataPoint<String>>.value(
              DsDataPoint<String>(
                type: DsDataType.string,
                name: DsPointName('/App/Jds/Subscribe'),
                value: '',
                status: DsStatus.ok,
                timestamp: DsTimeStamp.now().toString(),
                cot: DsCot.reqCon,
              ),
            ), 
          },
        ),
      );
      final result = await jdsService.subscribe([
        'Point.Name.0', 'Point.Name.1', 'PointName1', 
        'PointName2', 'PointName3', 'PointName4',
      ]);
      expect(result, isA<Ok>(), reason: 'Result should contain data');
    });
  });
}