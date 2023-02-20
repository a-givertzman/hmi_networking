import 'package:hmi_networking/hmi_networking.dart';
///
final dataSets = {
  'app-user-test': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'app_user_test',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-app-user',
      port: 8080,
    ),
  ),
  'event-test': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'event_view',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-event',
      port: 8080,
    ),
  ),
};
