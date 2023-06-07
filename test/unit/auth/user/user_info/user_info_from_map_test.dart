import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/auth/user/user_info.dart';

void main() {
  group('UserInfo fromMap', () {
    test('tries to read "group" or "groups" from map', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': '2',
          'group': 'admin',
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
        {
          'id': '1',
          'groups': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'password': '12345',
        },
        {
          'id': '0',
          'group': '',
          'name': 'abc123',
          'login': 'abc123',
          'password': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        if (userInfoArgs.containsKey('group')) {
          expect(userInfo.groups, [userInfoArgs['group']]);
        }
        else if (userInfoArgs.containsKey('groups')) {
          expect(userInfo.groups, userInfoArgs['groups']);
        }
      }
    });
    test('throws ArgumentError if empty groups array is provided', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'groups': [],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': '2',
          'groups': [],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
        {
          'id': '1',
          'groups': [],
          'name': 'abc123',
          'login': '123abc',
          'password': '12345',
        },
        {
          'id': '0',
          'groups': [],
          'name': 'abc123',
          'login': 'abc123',
          'password': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        expect(() => UserInfo.fromMap(userInfoArgs), throwsArgumentError);
      }
    });
     test('throws ArgumentError if there are no "group" or "groups" keys in map', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': '2',
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
        {
          'id': '1',
          'name': 'abc123',
          'login': '123abc',
          'password': '12345',
        },
        {
          'id': '0',
          'name': 'abc123',
          'login': 'abc123',
          'password': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        expect(() => UserInfo.fromMap(userInfoArgs), throwsArgumentError);
      }
    });
    test('prefers "group" key if "groups" key is also specified', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'group': 'admin',
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': '2',
          'group': 'operator1',
          'groups': [],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
        {
          'id': '1',
          'group': 'engineer_ogp',
          'groups': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'password': '12345',
        },
        {
          'id': '0',
          'group': '',
          'groups': ['guest'],
          'name': 'abc123',
          'login': 'abc123',
          'password': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        expect(userInfo.groups, [userInfoArgs['group']]);
      }
    });
    test('stringifies value of "id"', () {
      final userInfoTestArgs = [
        {
          'id': '123abc',
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': 3,
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': true,
          'groups': ['operator1'],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
        {
          'id': false,
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
        },
        {
          'id': -873,
          'groups': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'password': '12345',
        },
        {
          'id': 0.234,
          'groups': ['guest'],
          'name': 'abc123',
          'login': 'abc123',
          'password': '12345',
        },
        {
          'id': -0.234,
            'groups': ['operator1'],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'password': '12345',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        expect(userInfo.id, '${userInfoArgs['id']}');
      }
    });
    test('searches "pass" value if "password" is not specified', () {
      final userInfoTestArgs = [
        {
          'id': '3',
          'group': 'admin',
          'groups': [''],
          'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'login': 'test_login',
          'password': '12345',
          'pass': '1',
        },
        {
          'id': '2',
          'group': 'operator1',
          'groups': [],
          'name': '',
          'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
          'pass': '12345',
        },
        {
          'id': '1',
          'group': 'engineer_ogp',
          'groups': [
            '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
            '\rpdfokgo-0ero', 
            '\n daare90s943kf',
          ],
          'name': 'abc123',
          'login': '123abc',
          'password': '54321',
          'pass': 'abcabc',
        },
        {
          'id': '0',
          'group': '',
          'groups': ['guest'],
          'name': 'abc123',
          'login': 'abc123',
          'pass': 'admin',
        },
      ];
      for (final userInfoArgs in userInfoTestArgs) {
        final userInfo = UserInfo.fromMap(userInfoArgs);
        if (userInfoArgs.containsKey('password')) {
          expect(userInfo.password, userInfoArgs['password']);
        } else {
          expect(userInfo.password, userInfoArgs['pass']);
        }
      }
    });
  });
}