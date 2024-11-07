import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_result.dart';
/// 
/// Interface to communicate with remote device(s) in both ways by sending commands 
/// and receiving events (in the form of [DsDataPoint]s).
abstract interface class CustomProtocolLine {
  /// 
  /// Connection status with other device(s).
  bool get isConnected;
  ///
  /// Continuous flow of data from subordinate device(s).
  Stream<DsDataPoint> get stream;
  ///
  /// Requests all possible information from subordinated devices,
  /// including diagnostics.
  Future<ResultF<void>> requestAll();
  ///
  /// Send command to a particular device.
  Future<ResultF<void>> send(
    DsDataPoint point,
  );
  ///
  /// Close connection to device(s). 
  /// Unable to send commands and receiving events after this call.
  Future<void> close();
}