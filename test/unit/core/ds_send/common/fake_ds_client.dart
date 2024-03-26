import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';
///
class FakeDsClient implements DsClient {
  final Map<String, Stream<DsDataPoint>>? streams;
  ///
  FakeDsClient({this.streams});
  //
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) => 
    streams![name] as Stream<DsDataPoint<T>>;
  //
  @override
  Future<ResultF<void>> send(DsDataPoint point) {
    return Future.value(const Ok(null));
  }
  //
  @override
  bool isConnected() {
    throw UnimplementedError();
  }
  //
  @override
  Future<ResultF<void>> requestAll() {
    throw UnimplementedError();
  }
  //
  @override
  Future<ResultF<void>> requestNamed(List<String> names) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint> streamMerged(List<String> names) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false}) {
    throw UnimplementedError();
  }
  //
  @override
  int get subscriptionsCount => throw UnimplementedError();
}