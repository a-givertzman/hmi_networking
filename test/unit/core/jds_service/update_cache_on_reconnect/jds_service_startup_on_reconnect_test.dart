import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/hmi_networking.dart';
///
final class _FakeJdsStartup implements JdsServiceStartup {
  final Future<ResultF<void>> Function() _onRun;
  ///
  const _FakeJdsStartup({
    required Future<ResultF<void>> Function() onRun,
  }) : _onRun = onRun;
  //
  @override
  Future<ResultF<void>> run() => _onRun();
}
void main() {
  test('UpdateCacheOnReconnect .run() updates only once per reconnect', () async {
    int startupsCount = 0;
    final update = JdsServiceStartupOnReconnect(
      connectionStatuses: Stream.fromIterable(
        List.generate(100, 
          (index) => DsDataPoint<int>(
            type: DsDataType.integer,
            name: DsPointName('/'),
            value: DsStatus.ok.value,
            status: DsStatus.ok,
            timestamp: DsTimeStamp.now().toString(),
            cot: DsCot.inf,
          ),
        ),
      ), 
      startup: _FakeJdsStartup(
        onRun: () async {
          startupsCount += 1;
          return const Ok(null);
        },
      ),
    );
    final _ = update.run();
    // Waiting stream to fire its events
    await Future.delayed(Duration.zero);
    expect(startupsCount, equals(1));
  });
}