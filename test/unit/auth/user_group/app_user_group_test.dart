import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  group('AppUserGroup', () {
    test('create', () {
      expect(AppUserGroup(UserGroupList.admin), isInstanceOf<AppUserGroup>());
    });
    test('value', () {
      expect(AppUserGroup(UserGroupList.admin).value, equals(UserGroupList.admin));
      expect(AppUserGroup(UserGroupList.operator).value, equals(UserGroupList.operator));
    });
    test('text()', () {
      expect(AppUserGroup(UserGroupList.admin).text(), equals('Administrator'));
      expect(AppUserGroup(UserGroupList.operator).text(), equals('Operator'));
    });
    test('textOf()', () {
      expect(AppUserGroup(UserGroupList.operator).textOf(UserGroupList.admin), equals('Administrator'));
      expect(AppUserGroup(UserGroupList.admin).textOf(UserGroupList.operator), equals('Operator'));
    });    
  },);
}
