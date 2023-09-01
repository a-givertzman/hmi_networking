import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/core/entities/data_object.dart';

import 'fake_data_set.dart';

void main() {
  group('DataObject isEmpty', () {
    test('returns false if created with .empty() constructor', () {
      final dataObject = DataObject(remote: const FakeDataSet());
      expect(dataObject.isEmpty, false);
    });
    test('returns true if created with default constructor', () {
      final dataObject = DataObject.empty();
      expect(dataObject.isEmpty, true);
    });
  });
}