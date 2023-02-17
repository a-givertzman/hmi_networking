import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/api/api_handle_error.dart';
import 'package:hmi_networking/src/api/api_params.dart';
import 'package:hmi_networking/src/api/api_request.dart';
import 'package:hmi_networking/src/api/json_to.dart';
import 'package:hmi_networking/src/core/entities/response.dart';
///
class DataSet<T> {
  static const _debug = false;
  final ApiRequest _apiRequest;
  final ApiParams _params;
  final bool empty;
  ///
  const DataSet({
    required ApiRequest apiRequest,
    required ApiParams params,
  }):
    _apiRequest = apiRequest,
    _params = params,
    empty = false;
  ///
  const DataSet.empty():
    _apiRequest = const ApiRequest(url: '', port: 8080, api: ''),
    _params = const ApiParams.empty(),
    empty = true;
  /// 
  /// Возвращает новый DataSet с прежним запросом ApiRequest и обновленными params
  /// Прежние параметры остануться и дополняться новыми 
  DataSet<T> withParams({required Map<String, dynamic> params}) {
    final uParams = _params.updateWith(params);
    return DataSet<T>(
      apiRequest: _apiRequest, 
      params: uParams,
    );
  }
  ///
  Future<Response<Map<String, dynamic>>> fetch() {
    log(_debug, '[${DataSet<T>}.fetch]');
    return _fetch(_apiRequest, _params);
  }
  ///
  Future<Response<Map<String, dynamic>>> fetchWith({required Map<String, dynamic> params}) {
    log(_debug, '[${DataSet<T>}.fetchWith]');
    final uParams = _params.updateWith(params);
    return _fetch(_apiRequest, uParams);
  }
  ///
  Future<Response<Map<String, dynamic>>> _fetch(ApiRequest apiRequest, ApiParams params) {
    log(_debug, '[${DataSet<T>}._fetch]');
    return ApiHandleError<Map<String, dynamic>>(
      json: JsonTo<Map<String, dynamic>>(
        request: apiRequest,
      ),
    ).fetch(params: params);
  }
}
