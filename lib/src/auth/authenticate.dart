import 'package:hmi_core/hmi_core.dart';
import 'auth_result.dart';
import 'user/app_user_single.dart';
///
class Authenticate {
  static const _debug = true;
  final _storeKey = 'spwd';
  final String _passwordKey;
  AppUserSingle _user;
  ///
  Authenticate({
    required AppUserSingle user,
    required String passwordKey,
  }) :
    _user = user,
    _passwordKey = passwordKey;
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
        message: const Localized('Please authenticate to continue...').v,
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
            message: '${response.errorMessage}\n\n${const Localized('Try to check network connection')} ${const Localized('to the database')}.\n', 
            user: _user,
          );
        } else {
          final exists = _user.exists();
          return AuthResult(
            authenticated: exists, 
            message: exists ? const Localized('Ok').v : const Localized('User not found').v, 
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
      message: 'Authenticated as: ${const Localized('Guest')}',
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
            message: '${response.errorMessage}\n\n${const Localized('Try to check network connection')} ${const Localized('to the database')}.\n',
            user: _user,
          );
        }
        if (_user.exists() &&  passIsValid) {
          final localStore = LocalStore();
          localStore.writeStringEncoded(_storeKey, login);
          return AuthResult(
            authenticated: true, 
            message: const Localized('Authenticated successfully').v,
            user: _user,
          );
        } else {
          final message = !_user.exists()
            ? '${const Localized('User')} $login ${const Localized('is not found')}.'
            : !passIsValid
              ? const Localized('Wrong login or password').v
              : const Localized('Authentication error').v;
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
          message:  '${const Localized('Authentication error')}:\n$error',
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
          message: const Localized('Authenticated successfully').v,
          user: _user,
        );
      } else {
        return AuthResult(
          authenticated: false, 
          message: '${const Localized('User')} $phoneNumber ${const Localized('is not found')}.',
          user: _user,
        );
      }
    })
    .catchError((error) {
      return AuthResult(
        authenticated: false, 
        message: '${const Localized('Authentication error')}:\n$error',
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
      message: const Localized('Logged out').v, 
      user: _user,
    );
  }
}
