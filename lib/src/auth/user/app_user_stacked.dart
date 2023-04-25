import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/auth/user_group/user_group.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'app_user.dart';
import 'app_user_single.dart';

///
class AppUserStacked extends AppUser {
  final _users = Stacked<AppUserSingle>();
  ///
  AppUserStacked({
    AppUserSingle? appUser,
  }) {
    if (appUser != null) {
      _users.push(appUser);
    }
  } 
  ///
  /// returns List<AppUserSingle> - list of all stored users
  List<AppUserSingle> toList() {
    return _users.toList();
  }
  ///
  /// returns AppUserSingle at top of stack without removing it
  AppUserSingle get peek => _users.peek;
  /// 
  /// add a AppUserSingle to the top of the stack
  void push(AppUserSingle user) {
    _users.push(user);
  }
  ///
  /// removes and returns a AppUserSingle from the top of the stack
  AppUserSingle pop() => _users.pop();
  //
  @override
  AppUserSingle clear() {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.clear();
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "clear" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  bool exists() {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.exists();
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "exists" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}}) {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.fetch();
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "fetch" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.fetchByLogin(login);
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "fetchByLogin" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  UserGroup userGroup() {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.userGroup();
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "userGroup" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  bool valid() {
    if (_users.isNotEmpty) {
      final user = _users.peek;
      return user.valid();
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе "valid" класса [$runtimeType] нет ни одного пользователя в стэке',
      stackTrace: StackTrace.current,
    );
  }
}
