import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/auth/user/user_info.dart';

void main() {
  test("UserInfo asMap returns provided fields", () {
    final userInfoTestArgs = [
      {
        'id': '0',
        'groups': [''],
        'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'login': 'test_login',
        'password': 'some_goofy_password',
      },
      {
        'id': 'sdfgsdgfsdg3425',
        'groups': [],
        'name': '',
        'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'password': '12345',
      },
      {
        'id': '243090-54390',
        'groups': [
          '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
          '\rpdfokgo-0ero', 
          '\n daare90s943kf',
        ],
        'name': 'test\tname',
        'login': '',
        'password': '12345',
      },
      {
        'id': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'groups': [],
        'name': 'abc123',
        'login': 'abc123',
        'password': '',
      },
      {
        'id': '',
        'groups': [],
        'name': '123',
        'login': '12345',
        'password': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
      },
    ];
    for (final userInfoArgs in userInfoTestArgs) {
      final userInfo = UserInfo(
        id: userInfoArgs['id'] as String, 
        groups: (userInfoArgs['groups'] as List).cast<String>(), 
        name: userInfoArgs['name'] as String, 
        login: userInfoArgs['login'] as String, 
        password: userInfoArgs['password'] as String,
      );
      expect(userInfo.asMap(), equals(userInfoArgs));
    }
  });
}