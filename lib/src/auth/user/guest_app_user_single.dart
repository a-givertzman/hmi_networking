part of 'app_user_single.dart';
///
class _GuestAppUserSingle implements AppUserSingle {
  static const _data = {
    'id': '0',
    'group': UserGroupList.guest,
    'name': 'Guest',
    'login': 'guest',
    'pass': 'guest',
  };
  ///
  const _GuestAppUserSingle();
  //
  @override
  bool exists() => true;
  //
  @override
  bool valid() => true;
  //
  @override
  UserGroup userGroup() => AppUserGroup('guest');
  //
  @override
  AppUserSingle clear() => this;
  //
  @override
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}}) {
    return Future.value(
      const Response(data: _data),
    );
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    return Future.value(
      const Response(data: _data),
    );
  }
  //
  @override
  Map<String, dynamic> asMap() => _data;
}