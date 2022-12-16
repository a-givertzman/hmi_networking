import 'dart:async';

import 'package:hmi_core/hmi_core.dart';

abstract class CustomProtocolLine {
  /// 
  bool get isConnected;
  ///
  /// TODO Documentation description to be writen
  Stream<DsDataPoint> get stream;
  ///
  /// Requests all possible information from subordinated devices,
  /// as well as diagnostics
  Future<Result<bool>> requestAll();
  ///
  /// TODO Documentation description to be writen
  Future<Result<bool>> send(
    DsCommand dsCommand,
  );
  ///
  /// TODO Documentation description to be writen
  Future close();
}