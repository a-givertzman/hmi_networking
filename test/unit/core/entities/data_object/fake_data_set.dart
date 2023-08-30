import 'package:hmi_networking/src/core/entities/response.dart';
import 'package:hmi_networking/src/datasource/data_set.dart';

class FakeDataSet<T> implements DataSet<T> {
  @override
  final bool empty;
  final Response<Map<String, dynamic>> _fetchResult;

  const FakeDataSet({
    this.empty = true, 
    Response<Map<String, dynamic>> fetchResult = const Response(data: {}),
  }) : _fetchResult = fetchResult;


  @override
  Future<Response<Map<String, dynamic>>> fetch() => Future.value(_fetchResult);

  @override
  Future<Response<Map<String, dynamic>>> fetchWith({required Map<String, dynamic> params}) {
    return Future.value(_fetchResult);
  }

  @override
  DataSet<T> withParams({required Map<String, dynamic> params}) => this;

}