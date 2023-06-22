import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/auth/user/user_info.dart';

void main() {
  group('UserInfo fromMap', () {
    test('tries to read "group" or "groups" from map', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'group': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': '2',
          'group': 'admin',
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
        {
          'id': '1',
          'group': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'pass': '12345',
        },
        {
          'id': '0',
          'group': '',
          'name': 'abc123',
          'login': 'abc123',
          'pass': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        if (userInfoArgs['group'] is List) {
          expect(userInfo.groups, userInfoArgs['group']);
        } else {
          expect(userInfo.groups, [userInfoArgs['group']]);
        }
      }
    });
    test('throws ArgumentError if empty group array is provided', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'group': [],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': '2',
          'group': [],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
        {
          'id': '1',
          'group': [],
          'name': 'abc123',
          'login': '123abc',
          'pass': '12345',
        },
        {
          'id': '0',
          'group': [],
          'name': 'abc123',
          'login': 'abc123',
          'pass': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        expect(() => UserInfo.fromMap(userInfoArgs), throwsArgumentError);
      }
    });
     test('throws ArgumentError if there are no "group" key in map', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': '2',
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
        {
          'id': '1',
          'name': 'abc123',
          'login': '123abc',
          'pass': '12345',
        },
        {
          'id': '0',
          'name': 'abc123',
          'login': 'abc123',
          'pass': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        expect(() => UserInfo.fromMap(userInfoArgs), throwsArgumentError);
      }
    });
    test('stringifies value of "id"', () {
      final userInfoTestArgs = [
        {
          'id': '123abc',
          'group': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': 3,
          'group': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': true,
          'group': ['operator1'],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
        {
          'id': false,
          'group': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'pass': '12345',
        },
        {
          'id': -873,
          'group': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'pass': '12345',
        },
        {
          'id': 0.234,
          'group': ['guest'],
          'name': 'abc123',
          'login': 'abc123',
          'pass': '12345',
        },
        {
          'id': -0.234,
            'group': ['operator1'],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        expect(userInfo.id, '${userInfoArgs['id']}');
      }
    });
  });
}