import 'package:hmi_core/src/core/entities/ds_data_point.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';

final class FakeDsClientCache implements DsClientCache {
  final Map<String, DsDataPoint> internalMap = {};
  FakeDsClientCache([Map<String, DsDataPoint> initialMap = const {}]) {
    internalMap.addAll(initialMap);
  }
  @override
  Future<void> add(DsDataPoint point) async {
    internalMap[point.name.name] = point;
  }

  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    internalMap.addEntries(
      points.map(
        (point) => MapEntry(point.name.name, point),
      ),
    );
  }

  @override
  Future<DsDataPoint?> get(String pointName) async => internalMap[pointName];

  @override
  Future<List<DsDataPoint>> getAll() async => internalMap.values.toList();

}