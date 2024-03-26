import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/cache/ds_client_cache.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client_connection_listener.dart';
import 'package:hmi_networking/src/protocols/custom_protocol_line.dart';

///
/// Клиент подключения к DataServer
class DsClientReal implements DsClient {
  static const _debug = true;
  bool _isActive = false;
  final CustomProtocolLine _line;
  final Map<String, StreamController<DsDataPoint>> _receivers = {};
  final DsClientCache? _cache;
  late final DsClientConnectionListener _dsClientConnectionListener;
    ///
  DsClientReal({
    required CustomProtocolLine line,
    DsClientCache? cache,
    FutureOr<void> Function(bool isConnected)? onConnectionChanged,
  }):
    _line = line,
    _cache = cache;
  ///
  /// текущее состояние подключения к серверу
  @override
  bool isConnected() => _line.isConnected;
  ///
  void _onCancel(StreamController<DsDataPoint>? controller) {
    log(_debug, '[$DsClientReal.onCancel] ');
    _receivers.removeWhere((key, value) => value == controller);
    if (controller != null) {
      controller.close();
    }
    controller = null;
  }
  //
  @override
  int get subscriptionsCount {
    return _receivers.length;
  }
  ///
  Stream<DsDataPoint<T>> _stream<T>(String name) {
    return switch(T) {
      bool => _streamToBool(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>,
      int => _streamToInt(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>,
      double => _streamToDouble(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>,
      String => _streamToString(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>,
      _ => _setupStreamController(name).stream as Stream<DsDataPoint<T>>,
    };
  }
  ///
  /// Вернет StreamController с именем [name] из Map<String, StreamContoller> _receivers
  /// если такой есть, если нет, то создаст.
  StreamController<DsDataPoint> _setupStreamController(String name) {
    if (!_receivers.containsKey(name)) {
      final streamController = StreamController<DsDataPoint>.broadcast(
        onListen: () async {
          if (!_isActive) {
            _isActive = true;
            log(_debug, '[$DsClientReal._setupStreamController] before _run');
            _dsClientConnectionListener = DsClientConnectionListener(
              _stream<int>('Local.System.Connection'),
              connectionStatus: _line.isConnected ? DsStatus.ok : DsStatus.invalid,
              onConnectionChanged: (connectionStatus) async {
                if (connectionStatus == DsStatus.ok) {
                  _line.requestAll();
                }
              },
            );
            _dsClientConnectionListener.run();
            _listenLine();
            log(_debug, '[$DsClientReal._setupStreamController] after _run');
          }
        },
      );
      streamController.onCancel = () => _onCancel(streamController);
      _receivers[name] = streamController;
      log(_debug, '[$DsClientReal._setupStreamController] value: $name,   streamCtrl: $streamController');
      return streamController;
    } else {
      if (_receivers.containsKey(name)) {
        final streamController = _receivers[name];
        if (streamController != null) {
          // log(_debug, '[$DsClientReal._setupStreamController] value: $name,   streamCtrl: $streamController');
          return streamController;
        } else {
          log(_debug, 'Ошибка в методе $DsClientReal._setupStreamController: streamController could not be null');
          throw Exception('Ошибка в методе $DsClientReal._setupStreamController: streamController could not be null');
        }
      } else {
        log(_debug, 'Ошибка в методе $DsClientReal._setupStreamController: name not found: $name');
        throw Exception('Ошибка в методе $DsClientReal._setupStreamController: name not found: $name');
      }
    }    
  }
  ///
  Stream<DsDataPoint<bool>> _streamToBool(Stream<DsDataPoint> stream, {bool inverse = false}) {
    return stream
      .map((event) {
        // log(_debug, '[$DsClientReal.streamBool.map] event: ', event.name, '\t', event.value);
        bool value = false;
        DsStatus status = event.status;
        if (event.value.runtimeType == bool) {
          value = event.value ^ inverse;
        } else {
          final parsedValue = int.tryParse('${event.value}');
          if (parsedValue != null) {
            value = (parsedValue > 0) ^ inverse;
          } else {
            log(_debug, '[$DsClientReal._streamToBool] bool.parse error for event: $event');
            status = DsStatus.invalid;
          }
        }
        return DsDataPoint<bool>(
          type: DsDataType.bool,
          name: event.name,
          value: value,
          status: status,
          cot: event.cot,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  Stream<DsDataPoint<int>> _streamToInt(Stream<DsDataPoint> stream, {int offset = 0}) {
    return stream
      .map((event) {
        // log(_debug, '[$DsClientReal.streamInt.map] event: ', event.name, '\t', event.value);
        int value = 0;
        DsStatus status = event.status;
        final parsedValue = int.tryParse('${event.value}');
        if (parsedValue != null) {
          value = parsedValue + offset;
        } else {
          log(_debug, 'int.parse error for event: $event');
          status = DsStatus.invalid;
        }
        return DsDataPoint<int>(
          type: DsDataType.integer,
          name: event.name,
          value: value,
          status: status,
          cot: event.cot,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  Stream<DsDataPoint<String>> _streamToString(Stream<DsDataPoint> stream) {
    return stream
      .map((event) {
        // log(_debug, '[$DsClientReal.streamInt.map] event: ', event.name, '\t', event.value);
        return DsDataPoint<String>(
          type: DsDataType.string,
          name: event.name,
          value: event.value.toString(),
          status: event.status,
          cot: event.cot,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  Stream<DsDataPoint<double>> _streamToDouble(Stream<DsDataPoint> stream, {double offset = 0.0}) {
    return stream
      .map((event) {
        // if (event.name == 'Capacitor.Capacity') {
        //   log(_debug, '[$DsClientReal.streamReal.map] event: ', event.name, '\t', event.value);
        // }
        double value = 0;
        DsStatus status = event.status;
        final parsedValue = double.tryParse('${event.value}');
        // if (event.name == 'Capacitor.Capacity') {
        //   log(_debug, '[$DsClientReal.streamReal.map] parsedValue: ', parsedValue);
        // }
        if (parsedValue != null) {
          value = parsedValue + offset;
        } else {
          log(_debug, 'double.parse error for event: $event');
          status = DsStatus.invalid;
        }
        return DsDataPoint<double>(
          type: DsDataType.real,
          name: event.name,
          value: value,
          status: status,
          cot: event.cot,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) {
    return _stream(name);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<bool>
  @override
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false}) {
    return _streamToBool(_stream(name), inverse: inverse);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>
  @override
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0}) {
    return _streamToInt(_stream(name), offset: offset);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>
  @override
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0}) {
    return _streamToDouble(_stream(name), offset: offset);
  }
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  @override
  Stream<DsDataPoint> streamMerged(List<String> names) {
    final List<Stream<DsDataPoint>> streams = [];
    for (final name in names) {
      streams.add(
        _stream(name),
      );
    }
    return StreamMerged(streams).stream;
  }
  ///
  /// Запускает DsClient в работу
  /// Подключается к DataServer
  /// Слушает socket, 
  /// раскидывает полученные события по подписчикам
  void _listenLine() {
    log(_debug, '[$DsClientReal]');
    _line.stream.listen(
      (dataPoint) {
        final name = dataPoint.name.name;
        // log(_debug, '[$DsClientReal.dataPoint] : $dataPoint');
        // log(_debug, '[$DsClientReal._listenLine] point name: ${dataPoint.name}');
        if (_receivers.containsKey(name)) {
          // log(_debug, '[$DsClientReal._run] dataPint: $dataPint');
          final receiver = _receivers[name];
          if (receiver != null && !receiver.isClosed) {
              // log(_debug, '[$DsClientReal._run] receiver: ${receiver}');
              receiver.add(dataPoint);
              _cache?.add(dataPoint);
          }
        }
      },
      onError: (e) {
        log(_debug, '[$DsClientReal._run] error: $e');
        // _socket.close();
      },
      onDone: () {
        log(_debug, '[$DsClientReal] done');
        _line.close();
      },
    );
    log(_debug, '[$DsClientReal] exit');
  }
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  @override
  Future<ResultF<void>> send(
    DsDataPoint point,
  ) {
    return _line.send(point);
  }
  ///
  /// Делает запрос на S7 DataServer что бы получить все точки данных
  /// что бы сервер прочитал и прислал значения всех точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  @override
  Future<ResultF<void>> requestAll() async {
    final cache = _cache;
    if (cache == null) {
      return _line.requestAll();
    } else {
      for(final entry in _receivers.entries.toList()) {
        final pointName = entry.key;
        final option = await cache.get(pointName);
        if(option case Some(value:final cachedPoint)) {
          final controller = entry.value;
          controller.add(cachedPoint);
        }
      }
      return const Ok(null);
    }
  }
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  @override
  Future<ResultF<void>> requestNamed(List<String> names) {
    return send(DsDataPoint(
      type: DsDataType.bool,
      name: DsPointName('/App/Jds/Gi'),
      value: names,
      status: DsStatus.ok,
      cot: DsCot.req,
      timestamp: DsTimeStamp.now().toString(),
    ));
  }
  ///
  /// Останавливаем цикл обработки входящего потока данных от S7 DataServer
  Future<void> cancel() {
    // TODO _dsClientConnectionListener must be released
    // _dsClientConnectionListener.close();
    return _line.close();
  }
}
