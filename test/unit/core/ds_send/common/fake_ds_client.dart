import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/ds_client.dart';
import 'package:hmi_networking/src/core/stream_mearged.dart';
//
class FakeDsClient implements DsClient {
  final Map<String, Stream<DsDataPoint>>? streams;
  //
  FakeDsClient({this.streams});
  //
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) => 
    streams![name] as Stream<DsDataPoint<T>>;
  //
  @override
  Future<Result<bool>> send(DsCommand dsCommand) {
    return Future.value(Result(data: true));
  }
  //
  @override
  bool isConnected() {
    throw UnimplementedError();
  }
  //
  @override
  Future<Result<bool>> requestAll() {
    throw UnimplementedError();
  }
  //
  @override
  Future<Result<bool>> requestNamed(List<String> names) {
    throw UnimplementedError();
  }
  //
  @override
  Result<bool> requestNamedEmulated(List<String> names) {
    throw UnimplementedError();
  }
  //
  @override
  Result<bool> sendEmulated(DsCommand dsCommand) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<bool>> streamBoolEmulated(String filterByValue, {int delay = 100}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<double>> streamEmulated(String filterByValue, {int delay = 100, double min = 0, double max = 100, int firstEventDelay = 0}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<int>> streamEmulatedInt(String filterByValue, {int delay = 100, double min = 0, double max = 100, int firstEventDelay = 0}) {
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
  StreamMerged<DsDataPoint> streamMergedEmulated(List<String> names) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0}) {
    throw UnimplementedError();
  }
  //
  @override
  Stream<DsDataPoint<double>> streamRequestedEmulated(String filterByValue, {int delay = 500, double min = 0, double max = 100}) {
    throw UnimplementedError();
  }
  //
  @override
  int get subscriptionsCount => throw UnimplementedError();
}