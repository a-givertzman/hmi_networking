import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import 'fake_data_set.dart';

void main() {
  group('DataObject valid()', () {
    test('returns false initially', () {
      final dataObject = DataObject(remote: const FakeDataSet());
      expect(dataObject.valid(), false);
    });
    test('returns true after successful data aquisition from row', () {
      final dataObject = DataObject(remote: const FakeDataSet());
      dataObject.fromRow(const {});
      expect(dataObject.valid(), true);
    });
    test('returns false after unsuccessful data aquisition from row', () {
      final dataObject = DataObject(remote: const FakeDataSet());
      dataObject.fromRow(const {});
      expect(dataObject.valid(), true);
      // non-string values will cause error
      dataObject.fromRow({'a': 1});
      expect(dataObject.valid(), false);
    });
    test('returns false after unsuccessful data aquisition from fetch', () async {
      final dataObject = DataObject(remote: const FakeDataSet());
      dataObject.fromRow(const {});
      expect(dataObject.valid(), true);
      // default FakeDataSet throws an Error on fetch
      await expectLater(dataObject.fetch(), throwsA(isA<Failure>()));
      expect(dataObject.valid(), false);
    });
  });
}