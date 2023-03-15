import 'package:hmi_core/hmi_core.dart';

///
class DsClientConnectionListener {
  DsStatus _connectionStatus;
  final Stream<DsDataPoint<int>> _stream;
  final void Function(DsStatus status) _onConnectionChanged;
  ///
  DsClientConnectionListener(
      this._stream, {
      required DsStatus connectionStatus,
      required void Function(DsStatus status) onConnectionChanged, 
    }) : 
      _connectionStatus = connectionStatus,
      _onConnectionChanged = onConnectionChanged;
  ///
  void run() {
    _stream.listen((event) {
      // log(_debug, '[$DsClientReal._run] event: $event');
      final status = DsStatus.fromValue(event.value);
      if (status != _connectionStatus) {
        _connectionStatus = status; 
        _onConnectionChanged(status);
      }
    });
  }
}