import 'package:hmi_networking/src/auth/user/app_user_single.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
///
abstract class AppUser {
  ///
  List<String> userGroups();
  ///
  bool exists();
  ///
  bool valid();
  ///  
  AppUserSingle clear();
  ///
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login);
}