import 'package:hmi_core/hmi_core.dart';
import 'auth_result.dart';
import 'user/app_user_single.dart';
///
class AuthMessages {
  final String authToContinue;
  final String checkNetwork;
  final String toDatabase;
  final String ok;
  final String userNotFound;
  final String guest;
  final String authenticatedSuccessfully;
  final String user;
  final String notFound;
  final String wrongLoginOrPassword;
  final String authError;
  final String loggedOut;

  AuthMessages({
    required this.authToContinue, 
    required this.checkNetwork,
    required this.toDatabase, 
    required this.ok,
    required this.userNotFound, 
    required this.guest, 
    required this.authenticatedSuccessfully, 
    required this.user, 
    required this.notFound, 
    required this.wrongLoginOrPassword, 
    required this.authError, 
    required this.loggedOut,
  });
}
///
class Authenticate {
  static const _debug = true;
  final _storeKey = 'spwd';
  final String _passwordKey;
  final AuthMessages _authMessages;
  AppUserSingle _user;
  ///
  Authenticate({
    required AppUserSingle user,
    required String passwordKey,
    required AuthMessages authMessages,
  }) :
    _user = user,
    _passwordKey = passwordKey,
    _authMessages = authMessages;
  ///
  AppUserSingle getUser() {
    return _user;
  }
  ///
  bool authenticated() {
    return _user.exists();
  }
  ///
  Future<AuthResult> authenticateIfStored() async {
    final localStore = LocalStore();
    final userLogin = await localStore.readStringDecoded(_storeKey);
    log(_debug, '[$Authenticate.authenticateIfStored] stored user: $userLogin');
    if (userLogin.isNotEmpty) {
      return authenticateByPhoneNumber(userLogin);
    } else {
      return AuthResult(
        authenticated: false, 
        message: _authMessages.authToContinue,
        user: _user,
      );
      // return Future.value(
      //   authenticateGuest(),
      // );
    }
  }
  ///
  Future<AuthResult> fetchByLogin(String login) {
    return _user.fetchByLogin(login)
      .then((response) {
        log(_debug, '[$Authenticate.fetchByLogin] response: ', response);
        log(_debug, '[$Authenticate.fetchByLogin] user: ', _user);
        if (response.hasError) {
          log(_debug, '[$Authenticate.fetchByLogin] error: ', response.errorMessage);
          return AuthResult(
            authenticated: false, 
            message: '${response.errorMessage}\n\n${_authMessages.checkNetwork} ${_authMessages.toDatabase}.\n', 
            user: _user,
          );
        } else {
          final exists = _user.exists();
          return AuthResult(
            authenticated: exists, 
            message: exists ? _authMessages.ok : _authMessages.userNotFound, 
            user: _user,
          );        
        }
      });
  }
  ///
  AuthResult authenticateGuest() {
    _user = AppUserSingle.guest();
    return AuthResult(
      authenticated: true, 
      message: 'Authenticated as: ${_authMessages.guest}',
      user: _user,
    );
  }
  ///
  Future<AuthResult> authenticateByLoginAndPass(String login, String pass) {
    log(_debug, '[$Authenticate.authenticateByLoginAndPass] login: $login');
    _user = _user.clear();
    return _user.fetchByLogin(login)
      .then((response) {
        log(_debug, '[$Authenticate.authenticateByLoginAndPass] user: $_user');
        final passLoaded = '${_user['pass']}';
        final passIsValid = UserPassword(value: pass, key: _passwordKey).encrypted() == passLoaded;
        if (response.hasError) {
          return AuthResult(
            authenticated: false, 
            message: '${response.errorMessage}\n\n${_authMessages.checkNetwork} ${_authMessages.toDatabase}.\n',
            user: _user,
          );
        }
        if (_user.exists() &&  passIsValid) {
          final localStore = LocalStore();
          localStore.writeStringEncoded(_storeKey, login);
          return AuthResult(
            authenticated: true, 
            message: _authMessages.authenticatedSuccessfully,
            user: _user,
          );
        } else {
          final message = !_user.exists()
            ? '${_authMessages.user} $login ${_authMessages.notFound}.'
            : !passIsValid
              ? _authMessages.wrongLoginOrPassword
              : _authMessages.authError;
          return AuthResult(
            authenticated: false, 
            message: message,
            user: _user,
          );
        }
      })
      .catchError((error) {
        return AuthResult(
          authenticated: false, 
          message:  '${_authMessages.authError}:\n${error.toString()}',
          user: _user,
          error: error as Exception,
        );
      });
  }
  ///
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    return _user.fetch(params: {
      'phoneNumber': phoneNumber,
    },).then((user) {
      log(_debug, '[$Authenticate.authenticateByPhoneNumber] user: $user');
      if (_user.exists()) {
        final localStore = LocalStore();
        localStore.writeStringEncoded(_storeKey, phoneNumber);
        return AuthResult(
          authenticated: true, 
          message: _authMessages.authenticatedSuccessfully,
          user: _user,
        );
      } else {
        return AuthResult(
          authenticated: false, 
          message: '${_authMessages.user} $phoneNumber ${_authMessages.notFound}.',
          user: _user,
        );
      }
    })
    .catchError((error) {
      return AuthResult(
        authenticated: false, 
        message: '${_authMessages.authError}:\n${error.toString()}',
        user: _user,
      );
    });
  }
  ///
  Future<AuthResult> logout() async {
    final localStore = LocalStore();
    await localStore.remove(_storeKey);
    _user = _user.clear();
    return AuthResult(
      authenticated: false, 
      message: _authMessages.loggedOut, 
      user: _user,
    );
  }
}
