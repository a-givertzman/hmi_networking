import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  // const debug = true;
  group('ApiRequest', () {
//     setUp(() async {
//       // return 0;
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
//   ('940', 'operator', 'anton lobanov', 'anton.lobanov4', '123qwe', '2022-04-26 15:52:28', '2022-04-26 15:52:28', NULL)
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
//     },);
    test('create', () {
      expect(const ApiRequest(url: '127.0.0.1', port: 8080, api: ''), isInstanceOf<ApiRequest>());
    });
    // test('fetch()', () async {
    //   await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'get-app-user')
    //     .fetch(
    //       params: ApiParams({
    //         'api-sql': 'select',
    //         'tableName': 'app_user_test',
    //     }),)
    //     .then((value) {
    //       log(debug, 'result: ', value);
    //       expect(value, '{"data": {"0": {"id": "935", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov", "pass": "123qwe", "created": "2022-04-26 15:46:22", "updated": "2022-04-26 15:46:22", "deleted": null}, "1": {"id": "937", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov1", "pass": "123qwe", "created": "2022-04-26 15:46:54", "updated": "2022-04-26 15:46:54", "deleted": null}, "2": {"id": "938", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov2", "pass": "123qwe", "created": "2022-04-26 15:48:03", "updated": "2022-04-26 15:48:03", "deleted": null}, "3": {"id": "939", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov3", "pass": "123qwe", "created": "2022-04-26 15:48:32", "updated": "2022-04-26 15:48:32", "deleted": null}, "4": {"id": "940", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov4", "pass": "123qwe", "created": "2022-04-26 15:52:28", "updated": "2022-04-26 15:52:28", "deleted": null}}, "errCount": 0, "errDump": {}}');
    //     });
    //   await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'get-app-user')
    //     .fetch(
    //       params: ApiParams({
    //         'api-sql': 'select',
    //         'tableName': 'wrong_table_name',
    //     }),)
    //     .then((value) {
    //       log(debug, 'result: ', value);
    //       expect(value.startsWith('{"data": {}, "errCount": 1,'), true);
    //     });
    // });
    // test('cycled fetch()', () async {
    //   const count = 100;
    //   for (int i = 0; i < count; i++) {
    //     await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'get-app-user')
    //       .fetch(
    //         params: ApiParams({
    //           'api-sql': 'select',
    //           'tableName': 'app_user_test',
    //       }),)
    //       .then((value) {
    //         log(debug, 'result: ', value);
    //         expect(value, '{"data": {"0": {"id": "935", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov", "pass": "123qwe", "created": "2022-04-26 15:46:22", "updated": "2022-04-26 15:46:22", "deleted": null}, "1": {"id": "937", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov1", "pass": "123qwe", "created": "2022-04-26 15:46:54", "updated": "2022-04-26 15:46:54", "deleted": null}, "2": {"id": "938", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov2", "pass": "123qwe", "created": "2022-04-26 15:48:03", "updated": "2022-04-26 15:48:03", "deleted": null}, "3": {"id": "939", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov3", "pass": "123qwe", "created": "2022-04-26 15:48:32", "updated": "2022-04-26 15:48:32", "deleted": null}, "4": {"id": "940", "group": "operator", "name": "anton lobanov", "login": "anton.lobanov4", "pass": "123qwe", "created": "2022-04-26 15:52:28", "updated": "2022-04-26 15:52:28", "deleted": null}}, "errCount": 0, "errDump": {}}');
    //       });
    //   }
    //   for (int i = 0; i < count; i++) {
    //     await const ApiRequest(url: '127.0.0.1', port: 8080, api: 'get-app-user')
    //       .fetch(
    //         params: ApiParams({
    //           'api-sql': 'select',
    //           'tableName': 'wrong_table_name',
    //       }),)
    //       .then((value) {
    //         log(debug, 'result: ', value);
    //         expect(value.startsWith('{"data": {}, "errCount": 1,'), true);
    //       });
    //   }
    // });
  },);
}
