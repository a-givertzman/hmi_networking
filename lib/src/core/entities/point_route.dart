import 'package:hmi_core/hmi_core.dart';
/// 
/// Prepends route path to point names.
abstract interface class PointRoute {
  ///
  /// [PointRoute] that prepends nothing to point names.
  const factory PointRoute.empty() = _EmptyRoute;
  /// 
  /// Prepend route path to point name.
  DsPointName join(DsPointName pointName);
}

///
class _EmptyRoute implements PointRoute {
  ///
  const _EmptyRoute();
  //
  @override
  DsPointName join(DsPointName pointName) => pointName;
}