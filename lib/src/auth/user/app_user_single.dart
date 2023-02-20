import 'package:hmi_networking/src/auth/user_group/app_user_group.dart';
import 'package:hmi_networking/src/auth/user_group/user_group.dart';
import 'package:hmi_networking/src/core/entities/data_object.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'package:hmi_networking/src/datasource/data_set.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/datasource/data_source.dart';
import 'app_user.dart';

///
class AppUserSingle extends DataObject implements AppUser {
  ///
  /// - remote - optional parameter, 
  /// - by default will be used DataSource().dataSet('app-user'))
  AppUserSingle({
    DataSet<Map<String, String>>? remote, 
  }) :
    super(remote: remote ?? DataSource.dataSet('app-user')) {
    _init();
  }
  /// Создание гостевого пользователя.
  /// Используется при отсутствии связи или других прав доступа у пользователя
  AppUserSingle.guest({String name = 'Guest'}) :
    super(remote:const DataSet.empty())
  {
    _init();
    super.fromRow({
      'id': '0',
      'group': UserGroupList.guest,
      'name': name,
      'login': 'guest',
      'pass': 'guest',
    });
  }
  /// Метод возвращает новый экземпляр класса
  /// с прежним remote, но без данных
  @override
  AppUserSingle clear() {
    return AppUserSingle(remote: remote);
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
