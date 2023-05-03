// part of 'app_user_single.dart';
// ///
// class _GuestAppUserSingle implements AppUserSingle {
//   ///
//   const _GuestAppUserSingle();
//   //
//   @override
//   final info = const UserInfo(
//     id: '0', 
//     groups: [UserGroupList.guest], 
//     name: 'Guest', 
//     login: 'guest', 
//     password: 'guest',
//   );
//   //
//   @override
//   bool exists() => true;
//   //
//   @override
//   bool valid() => true;
//   //
//   @override
//   List<UserGroup> userGroups() => info.groups.map((group) => AppUserGroup(group)).toList();
//   //
//   @override
//   AppUserSingle clear() => this;
//   //
//   @override
//   Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
//     return Future.value(
//       Response(data: info.asMap()),
//     );
//   }
// }