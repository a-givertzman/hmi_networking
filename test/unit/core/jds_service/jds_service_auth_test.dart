import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
import '../ds_send/common/fake_ds_client.dart';

void main() {
  group('JdsServie .auth(token)', () {
    test('with token', () async {
      final jdsService = JdsService(
        dsClient: FakeDsClient(
          streams: {
            'Auth.Secret': Stream<DsDataPoint<String>>.value(
              DsDataPoint<String>(
                type: DsDataType.string,
                name: DsPointName('/App/Jds/Auth.Secret'),
                value: '',
                status: DsStatus.ok,
                timestamp: DsTimeStamp.now().toString(),
                cot: DsCot.reqCon,
              ),
            ), 
          },
        ),
      );
      final result = await jdsService.authenticate('');
      expect(result, isA<Ok>(), reason: 'Result should contain data');
    });
  });
}