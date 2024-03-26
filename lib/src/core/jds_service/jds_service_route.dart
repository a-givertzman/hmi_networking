import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_networking/src/core/entities/point_route.dart';

/// 
/// Prepends app name and service name to point names.
class JdsServiceRoute implements PointRoute {
  final Setting _appName;
  final Setting _serviceName;
  ///
  /// Prepends [appName] and [serviceName] to point names.
  const JdsServiceRoute({
    required Setting appName, 
    required Setting serviceName,
  }) : 
    _appName = appName,
    _serviceName = serviceName;
  //
  @override
  DsPointName join(DsPointName pointName) => DsPointName(
    '/$_appName/$_serviceName$pointName',
  );
}