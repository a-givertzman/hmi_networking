import 'package:hmi_core/src/core/entities/ds_data_point.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';

final class FakeDsClientCache implements DsClientCache {
  final Map<String, DsDataPoint> map = {};
  FakeDsClientCache([Map<String, DsDataPoint> initialMap = const {}]) {
    map.addAll(initialMap);
  }
  @override
  Future<void> add(DsDataPoint point) async {
    map[point.name.name] = point;
  }

  @override
  Future<void> addMany(Iterable<DsDataPoint> points) async {
    map.addEntries(
      points.map(
        (point) => MapEntry(point.name.name, point),
      ),
    );
  }

  @override
  Future<DsDataPoint?> get(String pointName) async => map[pointName];

  @override
  Future<List<DsDataPoint>> getAll() async => map.values.toList();

}