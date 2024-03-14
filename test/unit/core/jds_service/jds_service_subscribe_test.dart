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
      const subscribeData = [
        {
          'names': ['Name1', 'Name2', 'Name3'],
          'string': '["Name1","Name2","Name3"]',
        },
        {
          'names': [],
          'string': '[]',
        },
        {
          'names': ['1'],
          'string': '["1"]',
        },
        {
          'names': ['?)(*&^,&)', '!@#\$%', '^&Y', '*#_+-='],
          'string': '["?)(*&^,&)","!@#\$%","^&Y","*#_+-="]',
        },
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
      for(final entry in subscribeData) {
        final names = (entry['names'] as List).cast<String>();
        final namesString = entry['string'] as String;  
        final pointsPackage = JdsPackage<String>(
          type: JdsDataType.string,
          value: namesString,
          name: DsPointName('/App/Jds/Subscribe'),
          status: DsStatus.ok,
          cot: JdsCot.req,
          timestamp: DateTime.now(),
        );
        final result = await jdsService.subscribe(names);
        expect(result, isA<Ok>());
        expect(requestPackage.type, equals(pointsPackage.type));
        expect(requestPackage.value, equals(pointsPackage.value));
        expect(requestPackage.name, equals(pointsPackage.name));
        expect(requestPackage.status, equals(pointsPackage.status));
        expect(requestPackage.cot, equals(pointsPackage.cot));
      }
    });
  });
}