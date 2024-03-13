import 'package:hmi_core/hmi_core_result_new.dart';
/// 
/// Destination to send [I] entity and receive an answer as [O] through some protocol.
abstract interface class ProtocolEndpoint<I,O> {
  /// 
  /// Send [data] and receive desired answer according to protocol.
  Future<ResultF<O>> exchange(I data);
}