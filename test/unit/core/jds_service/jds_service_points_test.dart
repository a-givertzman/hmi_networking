import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
import 'package:hmi_networking/hmi_networking.dart';

import 'fake_jds_endpoint.dart';
//
void main() {
  Log.initialize();
  group('JdsService .points()', () {
    test('sends request and aquiring result correctly', () async {
      final okPackage = JdsPackage<String>(
        type: JdsDataType.string,
        value: '{}',
        name: DsPointName('/App/Test/JdsService'),
        status: DsStatus.ok,
        cot: JdsCot.reqCon,
        timestamp: DateTime.parse('2024-03-14 15:53:44.757341'),
      );
      final okConfig = JdsPointConfigs.fromMap({});
      final pointsPackage = JdsPackage<String>(
        type: JdsDataType.string,
        value: '',
        name: DsPointName('/App/Jds/Points'),
        status: DsStatus.ok,
        cot: JdsCot.req,
        timestamp: DateTime.now(),
      );
      late final JdsPackage requestPackage;
      final jdsService = JdsService(
        endpoint: FakeJdsEndpoint(
          onExchange: (package) async {
            requestPackage = package;
            return Ok(okPackage);
          },
        ),
      );
      final result = await jdsService.points();
      expect(result, isA<Ok>());
      expect((result as Ok<JdsPointConfigs, Failure>).value.names, equals(okConfig.names));
      expect(requestPackage.type, equals(pointsPackage.type));
      expect(requestPackage.value, equals(pointsPackage.value));
      expect(requestPackage.name, equals(pointsPackage.name));
      expect(requestPackage.status, equals(pointsPackage.status));
      expect(requestPackage.cot, equals(pointsPackage.cot));
    });
  });
}