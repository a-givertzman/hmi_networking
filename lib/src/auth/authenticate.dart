import 'package:hmi_core/hmi_core.dart';
import 'auth_result.dart';
import 'user/app_user_single.dart';
///
class Authenticate {
  static const _log = Log('Authenticate');
  final _storeKey = 'spwd';
  AppUserSingle _user;
  ///
  Authenticate({
    required AppUserSingle user,
  }) :
    _user = user;
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
    _log.debug('[.authenticateIfStored] stored user: "$userLogin"');
    if (userLogin.isNotEmpty) {
      return authenticateByPhoneNumber(userLogin, store: true);
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
    if (login.toLowerCase() == 'guest') {
      return authenticateGuest();
    }
    return _user.fetchByLogin(login)
      .then((response) {
        _log.debug('[.fetchByLogin] response: ', response);
        _log.debug('[.fetchByLogin] user: ', _user);
        if (response.hasError) {
          _log.debug('[.fetchByLogin] error: ', response.errorMessage);
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
  Future<AuthResult> authenticateGuest() async {
    _user = _user.asGuest();
    return AuthResult(
      authenticated: true, 
      message: const Localized('Authenticated successfully').v, 
      user: _user,
    );
  }
  ///
  Future<AuthResult> authenticateByLoginAndPass(String login, String pass, {bool store = false}) {
    _log.debug('[.authenticateByLoginAndPass] login: $login');
    _user = _user.clear();
    return _user.fetchByLogin(login)
      .then((response) {
        _log.debug('[.authenticateByLoginAndPass] user: $_user');
        if (response.hasError) {
          return AuthResult(
            authenticated: false, 
            message: '${response.errorMessage}\n\n${const Localized('Try to check network connection')} ${const Localized('to the database')}.\n',
            user: _user,
          );
        }
        final passLoaded = _user.info?.password;
        final passIsValid = UserPassword(value: pass).encrypted() == passLoaded;
        if (_user.exists() &&  passIsValid) {
          if (store) {
            final localStore = LocalStore();
            localStore.writeStringEncoded(_storeKey, login);
          }
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
  Future<AuthResult> authenticateByPhoneNumber(String login, {bool store = false}) {
    return _user.fetchByLogin(login).then((user) {
      _log.debug('[.authenticateByPhoneNumber] user: $user');
      if (_user.exists()) {
        if (store) {
          final localStore = LocalStore();
          localStore.writeStringEncoded(_storeKey, login);
        }
        return AuthResult(
          authenticated: true, 
          message: const Localized('Authenticated successfully').v,
          user: _user,
        );
      } else {
        return AuthResult(
          authenticated: false, 
          message: '${const Localized('User')} $login ${const Localized('is not found')}.',
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
    _log.debug('[.authenticateByPhoneNumber] removing user: "$_storeKey" from local store');
    await localStore.remove(_storeKey);
    _user = _user.clear();
    return AuthResult(
      authenticated: false, 
      message: const Localized('Logged out').v, 
      user: _user,
    );
  }
}
