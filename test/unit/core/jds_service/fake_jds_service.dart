import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/jds_point_configs.dart';
import 'package:hmi_networking/src/core/jds_service/jds_service.dart';
///
final class FakeJdsService implements JdsService {
  final Future<ResultF<void>> Function(String)? _onAuth;
  final Future<ResultF<JdsPointConfigs>> Function()? _onPoints;
  final Future<ResultF<void>> Function(List<String>)? _onSubscribe;
  ///
  const FakeJdsService({
    Future<ResultF<void>> Function(String token)? onAuth, 
    Future<ResultF<JdsPointConfigs>> Function()? onPoints, 
    Future<ResultF<void>> Function(List<String> names)? onSubscribe,
  }) : 
    _onAuth = onAuth, 
    _onPoints = onPoints, 
    _onSubscribe = onSubscribe;


  @override
  Future<ResultF<void>> authenticate(String token) => switch(_onAuth) {
    null => throw UnimplementedError(),
    _ => _onAuth!.call(token),
  };

  @override
  Future<ResultF<JdsPointConfigs>> points() => switch(_onPoints) {
    null => throw UnimplementedError(),
    _ => _onPoints!.call(),
  };

  @override
  Future<ResultF<void>> subscribe([List<String> names = const []]) => switch(_onSubscribe) {
    null => throw UnimplementedError(),
    _ => _onSubscribe!.call(names),
  };
}