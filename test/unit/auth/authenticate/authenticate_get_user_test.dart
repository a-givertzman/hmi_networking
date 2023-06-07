import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/src/auth/authenticate.dart';
import 'package:mocktail/mocktail.dart';

import 'app_user_single_mock.dart';

void main() {
  Log.initialize();
  test('Authenticate authenticated checks for user existance', () {
    final authenticatedUser = AppUserSingleMock();
    const isAuthenticated = true;
    when(authenticatedUser.exists).thenReturn(isAuthenticated);
    var authenticate = Authenticate(user: authenticatedUser);

    expect(authenticate.authenticated(), equals(isAuthenticated));
    verify(authenticatedUser.exists).called(1);

    final notAuthenticatedUser = AppUserSingleMock();
    when(notAuthenticatedUser.exists).thenReturn(!isAuthenticated);
    final anotherAuthenticate = Authenticate(user: notAuthenticatedUser);
    expect(anotherAuthenticate.authenticated(), equals(!isAuthenticated));
  });
}