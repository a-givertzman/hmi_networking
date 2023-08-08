import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  test('AuthResult.authenticated returns provided value', () {
    final authResultArguments = [
      {
        'is_authenticated': false,
        'message': '',
        'user': AppUserSingle.fromJson(const JsonMap('{}')),
      },
      {
        'is_authenticated': true,
        'message': 'test message',
        'user': AppUserSingle.fromJson(const JsonMap('')),
      },
      {
        'is_authenticated': true,
        'message': 'foo',
        'user': AppUserSingle.fromJson(const JsonMap('fake json')),
      },
      {
        'is_authenticated': false,
        'message': 'egg',
        'user': AppUserSingle.fromJson(const JsonMap('_')),
      },
    ];
    for (final authResultMap in authResultArguments) {
      final isAuthenticated = authResultMap['is_authenticated'] as bool;
      final message = authResultMap['message'] as String;
      final user = authResultMap['user'] as AppUserSingle;
      final authResult = AuthResult(
        authenticated: isAuthenticated, 
        message: message, 
        user: user,
      );
      expect(authResult.authenticated, equals(isAuthenticated));
    }
  });
}