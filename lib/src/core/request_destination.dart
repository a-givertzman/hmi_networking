import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract interface class RequestDestination<I,O> {
  Future<ResultF<O>> send(I data);
}