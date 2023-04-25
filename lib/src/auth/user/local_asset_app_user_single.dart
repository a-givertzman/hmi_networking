part of 'app_user_single.dart';
///
class _LocalAssetAppUserSingle implements AppUserSingle {
  bool _valid = false;
  final String _assetPath;
  final Map<String, dynamic> _map = {};
  ///
  _LocalAssetAppUserSingle(String assetPath) : 
    _assetPath = assetPath;
  //
  @override
  AppUserSingle clear() => _LocalAssetAppUserSingle(_assetPath);
  //
  @override
  bool exists() {
    if(!_valid) {
      return false;
    }
    return '${_map["id"]}' != '' 
      && '${_map["group"]}' != '' 
      && '${_map["name"]}' != '' 
      && '${_map["login"]}' != '' 
      && '${_map["pass"]}' != '';
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}}) {
    final login = params['login'];
    if (login == null) {
      _valid = false;
      return Future.value(
        Response(
          errCount: 1,
          errDump: 'Error in method $runtimeType.fetch(): no login provided.',
        ),
      );
    } else {
      return JsonMap.fromTextFile(
        TextFile.asset(_assetPath),
      )
      .decoded
      .then((map) {
        final userData = map[login] as Map<String, dynamic>?;
        if(userData == null) {
          _valid = false;
          return Response(
            errCount: 1,
            errDump: 'Error in method $runtimeType.fetch(): no user with login $login found.',
          );
        } else {
          _valid = true;
          _map.clear();
          _map.addAll(userData);
          return Response(
            data: userData,
          );
        }
      }); 
    }
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    return fetch(params: {
      'login': login,
    });
  }
  //
  @override
  UserGroup userGroup() => AppUserGroup(
    _map['group'],
  );
  //
  @override
  bool valid() => _valid;
  //
  @override
  Map<String, dynamic> asMap() => _map;
}