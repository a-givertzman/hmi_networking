import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/transport_connection.dart';

/// 
/// Interface for generating connections over binary exchange protocols. 
abstract interface class TransportProtocol {
  /// 
  /// Try to open a new connection.
  Future<ResultF<TransportConnection>> establishConnection();
}