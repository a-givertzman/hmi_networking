import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/auth/user/user_info.dart';

void main() {
  test("UserInfo asMap returns provided fields", () {
    final userInfoTestArgs = [
      {
        'id': '0',
        'group': [''],
        'name': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'login': 'test_login',
        'pass': 'some_goofy_password',
      },
      {
        'id': 'sdfgsdgfsdg3425',
        'group': [],
        'name': '',
        'login': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'pass': '12345',
      },
      {
        'id': '243090-54390',
        'group': [
          '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n', 
          '\rpdfokgo-0ero', 
          '\n daare90s943kf',
        ],
        'name': 'test\tname',
        'login': '',
        'pass': '12345',
      },
      {
        'id': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
        'group': [],
        'name': 'abc123',
        'login': 'abc123',
        'pass': '',
      },
      {
        'id': '',
        'group': [],
        'name': '123',
        'login': '12345',
        'pass': '~`!@"№#\$;%:^&?*()_-+=/\\\',.<> \n',
      },
    ];
    for (final userInfoArgs in userInfoTestArgs) {
      final userInfo = UserInfo(
        id: userInfoArgs['id'] as String, 
        groups: (userInfoArgs['group'] as List).cast<String>(), 
        name: userInfoArgs['name'] as String, 
        login: userInfoArgs['login'] as String, 
        password: userInfoArgs['pass'] as String,
      );
      expect(userInfo.asMap(), equals(userInfoArgs));
    }
  });
}