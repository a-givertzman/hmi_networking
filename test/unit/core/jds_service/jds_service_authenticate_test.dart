import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
import 'package:hmi_networking/hmi_networking.dart';

import 'fake_jds_endpoint.dart';
//
void main() {
  Log.initialize();
  group('JdsService .subscribe()', () {
    test('sends request and aquiring result correctly', () async {
      const authData = [
        '?)(*&^,&)',
        '!@#\$%',
        '^&Y',
        '*#_+-=',
        'Name1',
        'Name2',
        'Name3',
        '',
        '1',
        'sij34klsd123',
      ];
      final okPackage = JdsPackage<String>(
        type: JdsDataType.string,
        value: '',
        name: DsPointName('/App/Test/JdsService'),
        status: DsStatus.ok,
        cot: JdsCot.reqCon,
        timestamp: DateTime.parse('2024-03-14 15:53:44.757341'),
      );
      late JdsPackage requestPackage;
      final jdsService = JdsService(
        endpoint: FakeJdsEndpoint(
          onExchange: (package) async {
            requestPackage = package;
            return Ok(okPackage);
          },
        ),
      );
      for(final token in authData) {
        final authPackage = JdsPackage<String>(
          type: JdsDataType.string,
          value: token,
          name: DsPointName('/App/Jds/Authenticate'),
          status: DsStatus.ok,
          cot: JdsCot.req,
          timestamp: DateTime.now(),
        );
        final result = await jdsService.authenticate(token);
        expect(result, isA<Ok>());
        expect(requestPackage.type, equals(authPackage.type));
        expect(requestPackage.value, equals(authPackage.value));
        expect(requestPackage.name, equals(authPackage.name));
        expect(requestPackage.status, equals(authPackage.status));
        expect(requestPackage.cot, equals(authPackage.cot));
      }
    });
  });
}