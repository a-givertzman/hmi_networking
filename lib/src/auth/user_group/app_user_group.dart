import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_networking/src/auth/user_group/user_group.dart';
/// 
/// Константы групп пользователей в системе
class UserGroupList {
  static const admin = 'admin';
  static const operator = 'operator';
  static const guest = 'guest';
}
/// 
/// Класс работы с группами пользователей
class AppUserGroup implements UserGroup {
  final Map<String, String> _groups;
  late final String _group;
  ///
  AppUserGroup(String group, {
    String adminName = 'Administrator',
    String operatorName = 'Operator',
    String guestName = 'Guest',
  }) : 
  _groups = {
    UserGroupList.admin: adminName,
    UserGroupList.operator: operatorName,
    UserGroupList.guest: guestName,
  } {
    if (_groups.containsKey(group)) {
      _group = group;
    } else {
      throw Failure.convertion(
          message: "[UserGroup] '$group' несуществующая группа",
          stackTrace: StackTrace.current,
      );
    }
  }
  /// вернет значение группы
  @override
  String get value => _group;
  /// вернет текстовое представление группы
  @override
  String text() => textOf(_group);
  /// вернет текстовое представление группы переданной в параметре
  @override
  String textOf(String key) {
    if (_groups.containsKey(key)) {
      final status = _groups[key];
      if (status != null) {
        return status;
      }
    }
    throw Failure.unexpected(
      message: '[$runtimeType] $key - несуществующая группа',
      stackTrace: StackTrace.current,
    );
  }
}
