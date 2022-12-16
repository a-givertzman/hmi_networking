import 'dart:async';

import 'package:hmi_core/hmi_core.dart';

/// Поток объединяющий события из нескольких потоков Stream<DsDataPoint<bool>>
/// в один по логическому OR
class StreamMergedOr {
  // static const _debug = true;
  final List<bool> _closed = [];
  final List<Stream<DsDataPoint<bool>>>_streams;
  final StreamController<DsDataPoint<bool>> _streamController 
    = StreamController<DsDataPoint<bool>>();
  final Map<String, bool> _values = {};
  final Map<String, DsStatus> _statuses = {};
  ///
  StreamMergedOr(List<Stream<DsDataPoint<bool>>> streams) : 
  _streams = streams,
  super();
  ///
  Stream<DsDataPoint<bool>> get stream {
    _streamController.onListen = _onListen;
    return _streamController.stream;
  }
  ///
  void _onListen() {
    for (final stream in _streams) {
      _closed.add(false);
      // _values[stream.hashCode] = false;
      stream.listen(
        (event) {
          // log(_debug, 'event.value: ', event.value);
          // log(_debug, 'event.status: ', event.status);
          _values[event.name] = event.value;
          _statuses[event.name] = event.status;
          // log(_debug, 'values: ', _values);
          bool resultValue = false;
          for (final value in _values.values) {
            resultValue = resultValue || value;
          }
          _streamController.add(
            DsDataPoint(
              type: DsDataType.bool,
              path: event.path,
              name: event.name,
              value: resultValue,
              status: _resultStatus(),
              timestamp: event.timestamp,
            ),
          );
        },
        onError: (Object error, StackTrace stackTrace) {
          _streamController.addError(error, stackTrace);
        },
        onDone: () {
          if (_closed.isNotEmpty) {
            // TODO stream mast be removed from _values on done (issue #84)
            // _values.remove(_values[stream.hashCode]);
            _closed.removeLast();
            if (_closed.isEmpty) {
              _streamController.close();
            }
          }
        },
      );
    }
  }
  ///
  DsStatus _resultStatus() {
    DsStatus status = DsStatus.ok;
    for (final s in _statuses.values) {
      if (s.value > status.value) {
        status = s;
      }
    }
    return status;
  }
}
