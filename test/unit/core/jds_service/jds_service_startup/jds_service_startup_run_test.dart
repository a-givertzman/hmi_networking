import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service_startup.dart';
import '../fake_jds_service.dart';

void main() {
  test('JdsServiceStartup .run() requests points and subscribes on them', 
    () async {
      bool isPointsRequested = false;
      bool isSubscribed = false;
      bool isAuthRequested = false;
      final service = FakeJdsService(
        onPoints: () async {
          isPointsRequested = true;
          return const Ok(JdsPointConfigs({}));
        },
        onAuth: (_) async {
          isAuthRequested = true;
          return const Ok(null);
        },
        onSubscribe: (names) async {
          isSubscribed = true;
          return const Ok(null);
        },
      );
      final startup = JdsServiceStartup(
        service: service, 
      );
      final result = await startup.run();
      expect(result, isA<Ok>());
      expect(isAuthRequested, isTrue);
      expect(isPointsRequested, isTrue);
      expect(isSubscribed, isTrue);
    },
  );
}