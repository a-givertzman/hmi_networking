import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'package:hmi_core/hmi_core.dart';

import 'auth_data_source.dart';

void main() {
  group('Authenticate', () {
  DataSource.initialize(dataSets);
    const debug = true;
    final users = [
      {'exists': true, 'login': 'anton.lobanov', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov1', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov1', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov2', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov2', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov3', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov3', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov4', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov4', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov5', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov5', 'pass': '123qwe'},
      {'exists': true, 'login': 'anton.lobanov6', 'pass': '123qwe'},
      {'exists': false, 'login': 'anton_.lobanov6', 'pass': '123qwe'},
    ];
//     setUp(() async {
//       // return 0;
//       WidgetsFlutterBinding.ensureInitialized();
//       SharedPreferences.setMockInitialValues({});
//       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
//         .fetch(
//           params: ApiParams({
//             'api-sql': 'drop-table',
//             'sql': 'DROP TABLE IF EXISTS `app_user_test`;',
//         }),)
//         .then((value) {
//           log(debug, 'result: ', value);
//           expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
//         });
//       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
//         .fetch(
//           params: ApiParams({
//             'api-sql': 'create-table',
//             'sql': '''
// CREATE TABLE IF NOT EXISTS `app_user_test` (
//   `id` bigint unsigned NOT NULL AUTO_INCREMENT,
//   `group` enum('admin','operator') CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'operator' COMMENT 'Признак группировки',
//   `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'ФИО Потльзователя',
//   `login` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT ' Логин',
//   `pass` varchar(2584) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'Пароль',
//   `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
//   `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
//   `deleted` timestamp NULL DEFAULT NULL,
//   PRIMARY KEY (`id`,`login`),
//   UNIQUE KEY `login_UNIQUE` (`login`)
// ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Потльзователи';
// ''',
//         }),)
//         .then((value) {
//           log(debug, 'result: ', value);
//           expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
//         });
//       final pass = UserPassword(value: '123qwe').encrypted();
//       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
//         .fetch(
//           params: ApiParams({
//             'api-sql': 'insert',
//             'sql': '''
// INSERT INTO `app_user_test` (
//   `id`, `group`, `name`, `login`, `pass`, `created`, `updated`, `deleted`
// ) VALUES (
//   '935', 'operator', 'anton lobanov', 'anton.lobanov', '$pass', '2022-04-26 15:46:22', '2022-04-26 15:46:22', NULL
//   ),
//   ('937', 'operator', 'anton lobanov', 'anton.lobanov1', '$pass', '2022-04-26 15:46:54', '2022-04-26 15:46:54', NULL),
//   ('938', 'operator', 'anton lobanov', 'anton.lobanov2', '$pass', '2022-04-26 15:48:03', '2022-04-26 15:48:03', NULL),
//   ('939', 'operator', 'anton lobanov', 'anton.lobanov3', '$pass', '2022-04-26 15:48:32', '2022-04-26 15:48:32', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov4', '$pass', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov5', '$pass', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov6', '$pass', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL)
// ;''',
//         }),)
//         .then((value) {
//           log(debug, 'result: ', value);
//           expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
//         });
// //       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
// //         .fetch(
// //           params: ApiParams({
// //             'api-sql': 'insert',
// //             'sql': '''
// // INSERT INTO `app_user` (
// //   `id`, `group`, `name`, `login`, `pass`, `created`, `updated`, `deleted`
// // ) VALUES (
// //   '985', 'operator', 'anton lobanov', 'anton.lobanov6', '123qwe', '2022-04-26 15:46:22', '2022-04-26 15:46:22', NULL
// // );''',
// //         }))
// //         .then((value) {
// //           log(_debug, 'result: ', value);
// //           expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
// //         });
//     });
    test('create', () async {
      expect(
        Authenticate(
          user: AppUserSingle(
            remote: DataSource.dataSet('app-user-test'),
          ),
        ), 
        isInstanceOf<Authenticate>(),
      );
      final auth = Authenticate(
        user: AppUserSingle(
          remote:  DataSource.dataSet('app-user-test'),
        ),
      );
      log(debug, 'auth: ', auth);
      expect(auth, isInstanceOf<Authenticate>());
    });
    // test('authenticateByLoginAndPass()', () async {
    //   final auth = Authenticate(
    //     user: AppUserSingle(
    //       remote:  DataSource.dataSet('app-user-test'),
    //     ),
    //   );
    //   log(debug, 'auth: ', auth);
    //   for (var i = 0; i < users.length; i++) {
    //     final authResult = await auth.authenticateByLoginAndPass(
    //       '${users[i]['login']}',
    //       '${users[i]['pass']}',
    //     );
    //     log(debug, 'authResult: ', authResult);
    //     log(debug, 'auth.getUser(): ', auth.getUser());
    //     expect(authResult.authenticated, equals(users[i]['exists']));
    //     expect(authResult.user.exists(), equals(users[i]['exists']));
    //     expect(auth.getUser().exists(), equals(users[i]['exists']));
    //     expect(auth.authenticated(), equals(users[i]['exists']));
    //     await auth.logout();
    //   }
    // });
  });
}
