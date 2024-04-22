// ignore_for_file: no_runtimetype_tostring
import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'api_params.dart';
import 'api_request.dart';
///
class JsonTo<T> {
  static const _log = Log('JsonTo');
  final ApiRequest _request;
  ///
  const JsonTo({
    required ApiRequest request,
  }) :
  _request = request;
  ///
  Future<Response<T>> parse({required ApiParams params}) {
    _log.debug('<$T> [.parse] params: $params');
    return _request
      .fetch(params: params)
      .then((json) {
        _log.debug('<$T> [.parse] json: $json');
        if (json.isNotEmpty) {
          try {
            final T parsed = const JsonCodec().decode(json) as T;
            return Response(
              data: parsed,
              errCount: 0,
              errDump: '',
            );
          } catch (error) {
            _log.error('<$T> Ошибка в методе $runtimeType.parse() on json: "$json"\n\t$error');
            return Response(
              errCount: 1,
              errDump: 'Ошибка в методе $runtimeType.parse() $error',
            );
            // throw Failure.convertion(
            //   message: 'Ошибка в методе $runtimeType.parse() $error',
            //   stackTrace: StackTrace.current,
            // );
          }
        } else {
          _log.error('<$T> Ошибка в методе $runtimeType.parse() json is empty');
          return Response(
            errCount: 1,
            errDump: 'Ошибка в методе $runtimeType.parse() json is empty',
          );
        }
      });
  }
}
