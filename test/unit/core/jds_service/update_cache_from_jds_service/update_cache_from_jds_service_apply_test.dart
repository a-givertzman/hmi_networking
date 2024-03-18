import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_point_address.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_config.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_from_jds_service.dart';
import '../../ds_client/cache/delayed/fake_ds_client_cache.dart';
import '../fake_jds_service.dart';

void main() {
  test('UpdateCacheFromJdsService .apply() creates new points from service in cache', () async {
    const  addedPointConfig = {
      '/Point1': JdsPointConfig(
        type: DsDataType.string, 
        address: DsPointAddress(),
      ),
    };
    final expectedPoint = DsDataPoint(
      type: DsDataType.integer,
      name: DsPointName('/Point1'),
      value: 0,
      status: DsStatus.invalid,
      timestamp: DsTimeStamp.now().toString(),
      cot: DsCot.inf,
    );
  final cache = FakeDsClientCache();
    final cacheUpdate = UpdateCacheFromJdsService(
      cache: cache,
      jdsService: FakeJdsService(
        onPoints: () async => const Ok(
          JdsPointConfigs(addedPointConfig),
        ),
      ),
    );
    expect(await cache.getAll(), isEmpty);
    final result = await cacheUpdate.apply();
    expect(result, isA<Ok>());
    final cachedPoint = cache.internalMap['Point1'];
    expect(cachedPoint?.type, equals(expectedPoint.type));
    expect(cachedPoint?.name.toString(), equals(expectedPoint.name.toString()));
    expect(cachedPoint?.value, equals(expectedPoint.value));
    expect(cachedPoint?.status, equals(expectedPoint.status));
    expect(cachedPoint?.history, equals(expectedPoint.history));
    expect(cachedPoint?.alarm, equals(expectedPoint.history));
    expect(cachedPoint?.cot, equals(expectedPoint.cot));
  });
}