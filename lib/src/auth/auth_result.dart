import 'user/app_user_single.dart';
///
class AuthResult {
  final bool _authenticated;
  final String _message;
  final AppUserSingle _user;
  final Exception? _error;
  ///
  AuthResult({
    required bool authenticated,
    required String message,
    required AppUserSingle user,
    Exception? error,
  }):
    _authenticated = authenticated, 
    _message = message,
    _user = user,
    _error = error;
  ///
  bool get authenticated => _authenticated;
  ///
  String get message => _message;
  ///
  AppUserSingle get user => _user;
  ///
  Exception? get error => _error;
  ///
  @override
  String toString() {
    String str = '$AuthResult {';
    str += '\n\tauthenticated: $_authenticated,';
    str += '\n\tmessage: $_message,';
    str += '\n\tuser: $_user,';
    str += '\n\terror: $_error,';
    return str;
  }
}
