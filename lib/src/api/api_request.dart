import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hmi_core/hmi_core.dart';

import 'api_params.dart';

/// Класс реализует http запрос на url
/// с параметрами params
/// Возвращает строку json
class ApiRequest {
  static const _debug = true;
  final String _url;
  final String _api;
  final int _port;
  const ApiRequest({
    required String url,
    required String api,
    required int port,
  }): 
    _url = url,
    _api = api,
    _port = port;
  Future<String> fetch({required ApiParams params}) {
    log(_debug, '[ApiRequest.fetch]');
    return _fetchJsonFromUrl(_url, _port, _api, params);
  }

  Future<String> _fetchJsonFromUrl(String url, int port, String api, ApiParams params) async {
    log(_debug, '[ApiRequest._fetchJsonFromUrl] ip: $url:$port$api');
    return Socket
      .connect(url, _port, timeout: const Duration(seconds: 5))
      .then((socket) {
        final jsonData = params.toJson();
        log(_debug, '[ApiRequest._fetchJsonFromUrl] jsonData: ', jsonData);
        socket.add(
          utf8.encode(jsonData),
        );
        final Completer<String> complete = Completer();
        socket.listen(
          (event) {
            // print('event: $event');
            final str = String.fromCharCodes(event);
            // print('str: $str');
            if (!complete.isCompleted) {
              complete.complete(str);
            }
            socket.close();
          },
          onDone: () {
            log(_debug, '[ApiRequest.onDone]');
            if (!complete.isCompleted) {
              complete.complete('');
            }
            socket.close();
          },
          onError: (Object error) {
            log(_debug, '[ApiRequest.onError]');
            socket.close();
            return __connectionFailure(error, StackTrace.current);
          },
        );
        return complete.future;
      })
      .onError((error, stackTrace) {
        return __connectionFailure(error, stackTrace);
      });
  }
  Never __connectionFailure(Object? error, StackTrace stackTrace) {
    throw Failure.connection(
      message: 'Ошибка в методе $runtimeType._fetchFromUrl: $error',
      stackTrace: stackTrace,
    );
  }
  /// do not delete !!!
  /// reserved for badCertificateCallback
  // String _getBaseUrl(String url){
  //   var resUrl = url.substring(url.indexOf('://')+3);
  //   resUrl = resUrl.substring(0,resUrl.indexOf('/'));
  //   log(_debug, '[ApiRequest._getBaseUrl] url: $resUrl');
  //   return resUrl;
  // }
}
