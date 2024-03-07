import 'package:hmi_core/hmi_core_option.dart';
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
  Future<Option<DsDataPoint>> get(String pointName) async {
    final point = internalMap[pointName];
    return switch(point) {
      null => const None() as Option<DsDataPoint>, 
      _ => Some(point),
    };
  }

  @override
  Future<List<DsDataPoint>> getAll() async => internalMap.values.toList();

}