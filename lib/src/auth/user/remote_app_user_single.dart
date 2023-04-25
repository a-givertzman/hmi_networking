part of 'app_user_single.dart';

final DataSet<Map<String, String>> _remoteAppUser = DataSource.dataSet('app-user');
///
class _RemoteAppUserSingle extends DataObject implements AppUserSingle {
  ///
  /// - remote - optional parameter, 
  /// - by default will be used DataSource().dataSet('app-user'))
  _RemoteAppUserSingle({
    DataSet<Map<String, String>>? remote, 
  }) :
    super(remote: remote ?? _remoteAppUser) {
      _init();
    }

  /// Создание гостевого пользователя.
  /// Используется при отсутствии связи или других прав доступа у пользователя
  // AppUserSingle.guest() :
  //   super(remote: DataSource.dataSet('app-user'))
  // {
  //   _init();
  //   super.fromRow({
  //     'id': '0',
  //     'group': UserGroupList.guest,
  //     'name': 'Guest',
  //     'login': 'guest',
  //     'pass': 'guest',
  //   });
  // }
  ///
  bool get isGuest {
    return this['login'].value == 'guest';
  }
  /// Метод возвращает новый экземпляр класса
  /// с прежним remote, но без данных
  @override
  AppUserSingle clear() {
    return _RemoteAppUserSingle(remote: remote);
  }
  ///
  void _init() {
    this['id'] = const ValueString('');
    this['group'] = const ValueString('');
    this['name'] = const ValueString('');
    this['login'] = const ValueString('');
    this['pass'] = const ValueString('');
    this['account'] = const ValueString('');
    this['created'] = const ValueString('');
    this['updated'] = const ValueString('');
    this['deleted'] = const ValueString('');
  }
  /// Возвращает true после загрузки пользователя из базы
  /// если пользователь в базе есть, false если его там нет
  /// Возвращает null если еще не загружен
  @override
  bool exists() {
    if (!valid()) {
      return false;
    }
    if (valid() 
      && '${this["id"]}' != '' 
      && '${this["group"]}' != '' 
      && '${this["name"]}' != '' 
      && '${this["login"]}' != '' 
      && '${this["pass"]}' != ''
    ) {
      return true;
    } else {
      return false;
    }
  }
  //
  @override
  UserGroup userGroup() {
    if (valid()) {
      return AppUserGroup(
        '${this['group']}',
      );
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе userGroup класса [$runtimeType] пользователь еще не проинициализирован',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    return fetch(params: {
      'where': [
        {'operator': 'where', 'field': 'login', 'cond': '=', 'value': login},
      ],
    },);
  }
}