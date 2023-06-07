import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/src/auth/authenticate.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_user_single_mock.dart';

void main() {
  Log.initialize();
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Authenticate authenticateIfStored", () {
    test("returns failed auth result if no user is stored", () async {
      SharedPreferences.setMockInitialValues({});
      final user = AppUserSingleMock();
      final authenticate = Authenticate(user: user);
      final result = await authenticate.authenticateIfStored();
      expect(result.authenticated, false);
      verifyNever(() => user.exists());
      verifyNever(() => user.fetchByLogin(any()));
    });
     test("returns successful auth result if user is stored", () async {
      // const login = 'value1';
      const encodedLogin = 'dmFsdWUx';
      SharedPreferences.setMockInitialValues({
        'spwd': encodedLogin,
      });
      final user = AppUserSingleMock();
      when(() => user.exists()).thenReturn(true);
      when(() => user.fetchByLogin(any())).thenAnswer(
        (_) async => const Response(data: <String,dynamic>{}),
      );
      final authenticate = Authenticate(user: user);
      final result = await authenticate.authenticateIfStored();
      expect(result.authenticated, true);
      verify(() => user.exists()).called(1);
      verify(() => user.fetchByLogin(any())).called(1);
    });
  });
}