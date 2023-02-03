import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
// import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  const validDataSetName = 'app-user-test';
  const invalidDataSetName = 'app-user-test-invalid';
  final dataSets = {
    validDataSetName: DataSet<Map<String, String>>(
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
    'event': DataSet<Map<String, String>>(
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
  late DataSource dataSource = DataSource.initialize(dataSets);
  group('DataSource test', () {
    test('initialize with valid datasets', () {
      expect(() {
          dataSource = DataSource.initialize(dataSets);
          return dataSource;
        },
        isInstanceOf<DataSource>(),
        reason: 'DataSource constructor didn`t work with valid input',
      );
    });
    test('Get instance', () {
      expect(
        dataSource,
        isInstanceOf<DataSource>(),
        reason: 'DataSource constructor didn`t work with valid input',
      );
    });    
    test('get datasets by valid name', () {
      expect(
        dataSource.dataSet(validDataSetName),
        isInstanceOf<DataSet>(),
        reason: 'DataSource doesn`t returns data set by valid name',
      );
    });
    test('get datasets by invalid name', () {
      expect(
        () => dataSource.dataSet(invalidDataSetName),
        throwsA(isA<Failure>()),
        reason: 'DataSource doesn`t fails on invalid dataset name',
      );
    });
  });
}