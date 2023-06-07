import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/src/auth/authenticate.dart';

import 'app_user_single_mock.dart';

void main() {
  Log.initialize();
  test('Authenticate getUser returns the same provided instance of user', () {
    final user = AppUserSingleMock();
    final authenticate = Authenticate(user: user);
    expect(identical(authenticate.getUser(), user), isTrue);
  });
}