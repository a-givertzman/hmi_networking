import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/core/entities/data_object.dart';

import 'fake_data_set.dart';

void main() {
  group('DataObject.remote', () {
    test('returns provided remote', () {
      const providedRemote = FakeDataSet<Map<String,String>>();
      final dataObject = DataObject(remote: providedRemote);
      expect(identical(dataObject.remote, providedRemote), isTrue);
    });
  });
}