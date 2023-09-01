import 'package:hmi_networking/src/core/entities/response.dart';
import 'package:hmi_networking/src/datasource/data_set.dart';

class FakeDataSet<T> implements DataSet<T> {
  @override
  final bool empty;
  final Future<Response<Map<String, dynamic>>>? _fetchResult;

  const FakeDataSet({
    this.empty = true, 
    Future<Response<Map<String, dynamic>>>? fetchResult,
  }) : _fetchResult = fetchResult;


  @override
  Future<Response<Map<String, dynamic>>> fetch() => _fetchResult ?? Future.error(Error());

  @override
  Future<Response<Map<String, dynamic>>> fetchWith({required Map<String, dynamic> params}) {
    return fetch();
  }

  @override
  DataSet<T> withParams({required Map<String, dynamic> params}) => this;

}