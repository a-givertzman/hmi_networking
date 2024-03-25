import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_from_jds_service.dart';
import 'package:hmi_networking/src/core/jds_service/update_cache_on_reconnect.dart';
///
final class _FakeUpdateCacheFromJdsService implements UpdateCacheFromJdsService {
  final Future<ResultF<Map<String, DsPointName>>> Function() _onApply;
  ///
  const _FakeUpdateCacheFromJdsService({
    required Future<ResultF<Map<String, DsPointName>>> Function() onApply,
  }) : _onApply = onApply;
  //
  @override
  Future<ResultF<Map<String, DsPointName>>> apply() => _onApply();
}

void main() {
  test('UpdateCacheOnReconnect .run() updates only once per reconnect', () async {
    int updatesCount = 0;
    final update = UpdateCacheOnReconnect(
      connectionStatuses: Stream.fromIterable(
        List.generate(100, 
          (index) => DsDataPoint<bool>(
            type: DsDataType.bool,
            name: DsPointName('/'),
            value: true,
            status: DsStatus.ok,
            timestamp: DsTimeStamp.now().toString(),
            cot: DsCot.inf,
          ),
        ),
      ), 
      cacheUpdate: _FakeUpdateCacheFromJdsService(
        onApply: () async {
          updatesCount += 1;
          return const Ok({});
        },
      ),
    );
    final _ = update.run();
    // Waiting stream to fire its events
    await Future.delayed(Duration.zero);
    expect(updatesCount, equals(1));
  });
}