part of 'app_user_single.dart';
///
class _JsonAppUserSingle implements AppUserSingle {
  bool _valid = false;
  final JsonMap _json;
  ///
  UserInfo? _info;
  //
  @override
  UserInfo? get info => _info;
  ///
  _JsonAppUserSingle(JsonMap json) : 
    _json = json;
  //
  @override
  AppUserSingle asGuest() {
    _info = const UserInfo(
      id: '0', 
      groups: [UserGroupList.guest], 
      name: 'Guest', 
      login: 'guest', 
      password: 'guest',
    );
    _valid = true;
    return this;
  }
  //
  @override
  AppUserSingle clear() => _JsonAppUserSingle(_json);
  //
  @override
  bool exists() {
    if(!_valid) {
      return false;
    }
    return (_info?.id.isNotEmpty ?? false)
      && (_info?.groups.isNotEmpty ?? false)
      && (_info?.name.isNotEmpty ?? false)
      && (_info?.login.isNotEmpty ?? false)
      && (_info?.password.isNotEmpty ?? false);
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    return _json
    .decoded
    .then((map) {
      final userData = map[login] as Map<String, dynamic>?;
      if(userData == null) {
        _valid = false;
        return Response(
          errCount: 1,
          errDump: 'Error in method $runtimeType.fetchByLogin(): no user with login $login found.',
        );
      } else {
        _valid = true;
        _info = UserInfo.fromMap(userData..addAll({'login': login}));
        return Response(
          data: userData,
        );
      }
    }); 
  }
  //
  @override
  List<String> userGroups() => info?.groups ?? []; 
  //
  @override
  bool valid() => _valid;
}