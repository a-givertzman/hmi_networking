import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract class CustomProtocolLine {
  /// 
  bool get isConnected;
  ///
  /// TODO Documentation description to be writen
  Stream<DsDataPoint> get stream;
  ///
  /// Requests all possible information from subordinated devices,
  /// as well as diagnostics
  Future<ResultF<void>> requestAll();
  ///
  /// TODO Documentation description to be writen
  Future<ResultF<void>> send(
    DsCommand dsCommand,
  );
  ///
  /// TODO Documentation description to be writen
  Future<void> close();
}