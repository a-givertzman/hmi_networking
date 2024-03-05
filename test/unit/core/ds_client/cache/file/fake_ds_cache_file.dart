import 'package:hmi_core/src/core/entities/ds_data_point.dart';
import 'package:hmi_networking/src/core/ds_client/cache/file/ds_cache_file.dart';
///
class FakeDsCacheFile implements DsCacheFile {
  Map<String, DsDataPoint> internalMap = {};
  ///
  FakeDsCacheFile([Map<String, DsDataPoint> initialMap = const {}]) {
    internalMap.addAll(initialMap);
  }
  //
  @override
  Future<Map<String, DsDataPoint>> read() async => internalMap;
  //
  @override
  Future<void> write(Map<String, DsDataPoint> cache) async {
    internalMap = cache;
  }
}