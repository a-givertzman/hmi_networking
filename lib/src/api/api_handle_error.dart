import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
import 'api_params.dart';
import 'json_to.dart';

///
class ApiHandleError<T> {
  static const _log = Log('ApiHandleError');
  final JsonTo<Map<String, dynamic>> _json;
  ApiHandleError({
    required JsonTo<Map<String, dynamic>> json,
  }):
    _json = json;
  Future<Response<T>> fetch({required ApiParams params}) {
    _log.debug('<$T> [ApiHandleError.fetch]');
    return _json
      .parse(params: params)
      .then((parsedResponse) {
        _log.debug('<$T> [.fetch] parsedResponse: $parsedResponse');
        if (parsedResponse.hasData) {
          final sqlData = parsedResponse.data;
          if (sqlData != null) {
            final T? data = sqlData['data'] as T?;
            final int errCount = int.parse('${sqlData['errCount']}');
            final String errDump = '${sqlData['errDump']}';
            return Response<T>(
              errCount: errCount, 
              errDump: errDump, 
              data: data,
            );
          } else {
            return Response<T>(
              errCount: parsedResponse.errorCount, 
              errDump: parsedResponse.errorMessage, 
            );
          }
        } else {
          return Response<T>(
            errCount: parsedResponse.errorCount, 
            errDump: parsedResponse.errorMessage, 
          );

        }
      })
      .catchError((error, stackTrace) {
        return Response<T>(
          errCount: 1, 
          errDump: 'Ошибка в методе $runtimeType.fetch() $error', 
        );
        // throw Failure.unexpected(
        //   message: 'Ошибка в методе $runtimeType.fetch() $error',
        //   stackTrace: stackTrace,
        // );
      });
  }
}
