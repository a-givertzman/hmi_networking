import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
import '../fake_jds_service.dart';

void main() {
  test('JdsServiceStartup .run() requests points and subscribes on them', 
    () async {
      bool isPointsRequested = false;
      bool isSubscribed = false;
      final service = FakeJdsService(
        onPoints: () async {
          isPointsRequested = true;
          return const Ok(JdsPointConfigs({}));
        },
        onSubscribe: (names) async {
          isSubscribed = true;
          return const Ok(null);
        },
      );
      final startup = JdsServiceStartup(service: service);
      final result = await startup.run();
      expect(result, isA<Ok>());
      expect(isPointsRequested, isTrue);
      expect(isSubscribed, isTrue);
    },
  );
}