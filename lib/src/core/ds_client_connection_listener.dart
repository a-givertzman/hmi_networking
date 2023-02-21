import 'package:hmi_core/hmi_core.dart';

///
class DsClientConnectionListener {
  bool _isConnected;
  final Stream<DsDataPoint<bool>> _stream;
  final void Function(bool isConnected) _onConnectionChanged;
  ///
  DsClientConnectionListener(
      this._stream, {
      required bool isConnected,
      required void Function(bool isConnected) onConnectionChanged, 
    }) : 
      _isConnected = isConnected,
      _onConnectionChanged = onConnectionChanged;
  ///
  void run() {
    _stream.listen((event) {
      // log(_debug, '[$DsClientReal._run] event: $event');
      if (event.value != _isConnected) {
        _isConnected = event.value; 
        _onConnectionChanged(_isConnected);
      }
    });
  }
}