import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../auth_data_source.dart';

void main() {
  DataSource.initialize(dataSets);
  group('AppUser', () {
    const debug = true;
//     final users = [
//       {'exists': true, 'login': 'anton.lobanov'},
//       {'exists': false, 'login': 'anton_.lobanov'},
//       {'exists': true, 'login': 'anton.lobanov1'},
//       {'exists': false, 'login': 'anton_.lobanov1'},
//       {'exists': true, 'login': 'anton.lobanov2'},
//       {'exists': false, 'login': 'anton_.lobanov2'},
//       {'exists': true, 'login': 'anton.lobanov3'},
//       {'exists': false, 'login': 'anton_.lobanov3'},
//       {'exists': true, 'login': 'anton.lobanov4'},
//       {'exists': false, 'login': 'anton_.lobanov4'},
//       {'exists': true, 'login': 'anton.lobanov5'},
//       {'exists': false, 'login': 'anton_.lobanov5'},
//       {'exists': true, 'login': 'anton.lobanov6'},
//       {'exists': false, 'login': 'anton_.lobanov6'},
//     ];
//     setUp(() async {
//       // return 0;
//       // WidgetsFlutterBinding.ensureInitialized();
//       // SharedPreferences.setMockInitialValues({});
//       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
//         .fetch(
//           params: ApiParams({
//             'api-sql': 'drop-table',
//             'sql': 'DROP TABLE IF EXISTS `app_user_test`;',
//         }),)
//         .then((value) {
//           log(debug, 'result: ', value);
//           // expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
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
//           // expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
//         });
//       await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'create-test-table')
//         .fetch(
//           params: ApiParams({
//             'api-sql': 'insert',
//             'sql': '''
// INSERT INTO `app_user_test` (
//   `id`, `group`, `name`, `login`, `pass`, `created`, `updated`, `deleted`
// ) VALUES (
//   '935', 'operator', 'anton lobanov', 'anton.lobanov', '123qwe', '2022-04-26 15:46:22', '2022-04-26 15:46:22', NULL
//   ),
//   ('937', 'operator', 'anton lobanov', 'anton.lobanov1', '123qwe', '2022-04-26 15:46:54', '2022-04-26 15:46:54', NULL),
//   ('938', 'operator', 'anton lobanov', 'anton.lobanov2', '123qwe', '2022-04-26 15:48:03', '2022-04-26 15:48:03', NULL),
//   ('939', 'operator', 'anton lobanov', 'anton.lobanov3', '123qwe', '2022-04-26 15:48:32', '2022-04-26 15:48:32', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov4', '123qwe', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov5', '123qwe', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL),
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov6', '123qwe', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL)
// ;''',
//         }),)
//         .then((value) {
//           log(debug, 'result: ', value);
//           // expect(value, '{"data": {}, "errCount": 0, "errDump": {}}');
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
//     },);
    test('create', () async {
      final appUser = AppUserSingle(
        remote: DataSource.dataSet('app-user-test'),
      );
      log(debug, 'appUser: ', appUser);
      expect(appUser, isInstanceOf<AppUserSingle>());
      expect(AppUserSingle(remote: const DataSet.empty()), isInstanceOf<AppUserSingle>());
    });
    // test('clear()', () async {
    //   final DataSet<Map<String, String>> remote = DataSource.dataSet('app-user-test');
    //   final appUser = AppUserSingle(
    //     remote: remote,
    //   );
    //   await appUser.fetch();
    //   log(debug, 'appUser: ', appUser);
    //   expect(appUser, isInstanceOf<AppUserSingle>());
    //   log(debug, 'appUser.name: ', appUser['name']);
    //   expect(appUser['name'].toString().isNotEmpty, equals(true));
    //   final appUserClear = appUser.clear();
    //   log(debug, 'appUserClear: ', appUserClear);
    //   expect(appUserClear, isInstanceOf<AppUserSingle>());
    //   expect(appUserClear.valid(), equals(false));
    //   expect(appUserClear['name'].toString().isEmpty, equals(true));
    //   expect(appUserClear.remote, equals(remote));
    // });
    // test('exists()', () async {
    //   final DataSet<Map<String, String>> remote = DataSource.dataSet('app-user-test');
    //   final appUser = AppUserSingle(
    //     remote: remote,
    //   );
    //   log(debug, 'appUser empty: ', appUser);
    //   expect(appUser, isInstanceOf<AppUserSingle>());
    //   expect(appUser.valid(), equals(false));
    //   expect(appUser.exists(), equals(false));
    //   await appUser.fetch();
    //   log(debug, 'appUser fetched: ', appUser);
    //   expect(appUser, isInstanceOf<AppUserSingle>());
    //   expect(appUser.valid(), equals(true));
    //   expect(appUser.exists(), equals(true));
    // });
    // test('fetch()', () async {
    //   for (var i = 0; i < users.length; i++) {
    //     final appUser = AppUserSingle(
    //       remote: DataSource.dataSet('app-user-test'),
    //     );
    //     await appUser.fetch(params: {
    //       'where': [
    //         {'operator': 'where', 'field': 'login', 'cond': '=', 'value': users[i]['login']},
    //       ],
    //     },)
    //       .then((response) {
    //         // log(_debug, 'appUser: ', appUser);
    //         expect(appUser, isInstanceOf<AppUserSingle>());
    //         expect(appUser.exists(), equals(users[i]['exists']));
    //         return appUser;
    //       });
    //   }
    // });
    // test('fetchByLogin()', () async {
    //   for (var i = 0; i < users.length; i++) {
    //     final appUser = AppUserSingle(
    //       remote: DataSource.dataSet('app-user-test'),
    //     );
    //     await appUser.fetchByLogin('${users[i]['login']}')
    //       .then((response) {
    //         // log(_debug, 'appUser: ', appUser);
    //         expect(appUser, isInstanceOf<AppUserSingle>());
    //         expect(appUser.exists(), equals(users[i]['exists']));
    //         return appUser;
    //       });
    //   }
    // });
  },);
}
