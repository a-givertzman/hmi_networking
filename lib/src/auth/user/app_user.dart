import 'package:hmi_networking/src/auth/user/app_user_single.dart';
import 'package:hmi_networking/src/auth/user_group/user_group.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
///
abstract class AppUser {
  ///
  UserGroup userGroup();
  ///
  bool exists();
  ///
  bool valid();
  ///  
  AppUserSingle clear();
  ///
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login);
  ///
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}});
}