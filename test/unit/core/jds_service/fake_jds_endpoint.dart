import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/jds/jds_endpoint.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_package.dart';

///
final class FakeJdsEndpoint implements JdsEndpoint {
  final Future<ResultF<JdsPackage>> Function(JdsPackage) _onExchange;
  ///
  const FakeJdsEndpoint({
    required Future<ResultF<JdsPackage>> Function(JdsPackage) onExchange,
  }) : _onExchange = onExchange;
  //
  @override
  Future<ResultF<JdsPackage>> exchange(JdsPackage package) => _onExchange(package);
}