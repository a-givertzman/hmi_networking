import 'package:hmi_core/hmi_core.dart';

///
class DsClientConnectionListener {
  int _connectionStatus;
  final Stream<DsDataPoint<int>> _stream;
  final void Function(int isConnected) _onConnectionChanged;
  ///
  DsClientConnectionListener(
      this._stream, {
      required int connectionStatus,
      required void Function(int status) onConnectionChanged, 
    }) : 
      _connectionStatus = connectionStatus,
      _onConnectionChanged = onConnectionChanged;
  ///
  void run() {
    _stream.listen((event) {
      // log(_debug, '[$DsClientReal._run] event: $event');
      if (event.value != _connectionStatus) {
        _connectionStatus = event.value; 
        _onConnectionChanged(_connectionStatus);
      }
    });
  }
}