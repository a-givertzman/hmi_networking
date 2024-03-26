// ignore_for_file: unused_field
import 'dart:async';
import 'dart:math';

import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';

///
class EmulationParams {
  final DsPointName filterByValue;
  final int delay;
  final double min; 
  final double max; 
  final int firstEventDelay;
  ///
  const EmulationParams({
    required this.filterByValue,
    this.delay = 0,
    this.min = 0,
    this.max = 0,
    this.firstEventDelay = 0,
  });
}

///
/// Методы работающие только в режиме эмуляции для удобства тестирования
class DsClientFake implements DsClient {
  static final _log = const Log('DsClientFake')..level = LogLevel.info;
  final Map<String, StreamController<DsDataPoint>> _receivers = {};
  final Map<String, CustomDataGenerator> _generators = {};
  late StreamTransformer doubleTransformer;
  final bool _isConnected;
  final EmulationParams _streamParams;
  final EmulationParams _streamMergedParams;
  final EmulationParams _streamBoolParams;
  final EmulationParams _streamIntParams;
  final EmulationParams _streamRealParams;
  final EmulationParams _requestAllParams;
  /// Методы работающие только в режиме эмуляции для удобства тестирования
  DsClientFake({
    required EmulationParams streamParams,
    required EmulationParams streamMergedParams,
    required EmulationParams streamBoolParams,
    required EmulationParams streamIntParams,
    required EmulationParams streamRealParams,
    required EmulationParams requestAllParams,
    bool isConnected = true,
  }) :
    _streamParams = streamParams, 
    _streamMergedParams = streamMergedParams, 
    _streamBoolParams = streamBoolParams, 
    _streamIntParams = streamIntParams,
    _streamRealParams = streamRealParams,
    _requestAllParams = requestAllParams,
    _isConnected = isConnected;
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) {
    return _streamEmulated(
      _streamParams.filterByValue,
      delay: _streamParams.delay,
      max: _streamParams.max,
      min: _streamParams.min,
      firstEventDelay: _streamParams.firstEventDelay,
    ).transform(
      StreamTransformer<DsDataPoint<double>, DsDataPoint<T>>.fromHandlers(handleData: _handleToTStreamData),
    );
  }
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  @override
  Stream<DsDataPoint> streamMerged(List<String> names) {
    final List<Stream<DsDataPoint>> streams = [];
    for (final name in names) {
      streams.add(
        streamInt(name),
      );
    }
    return StreamMerged(streams).stream;
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
    throw Failure.unexpected(
      message: '[$DsClientFake.send] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке
  /// В качестве результата Result<bool> получает результат чтения из S7 
  /// данные не ждем, они прийдут в потоке
  @override
  Future<ResultF<void>> requestNamed(List<String> names) {
    throw Failure.unexpected(
      message: '[$DsClientFake.requestNamed] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false}) {
    final doubleTransformer = StreamTransformer<DsDataPoint<double>, DsDataPoint<bool>>.fromHandlers(handleData: _handleToBoolStreamData);
    return _streamEmulated(_streamBoolParams.filterByValue, delay: _streamBoolParams.delay, max: _streamBoolParams.max)
      .transform<DsDataPoint<bool>>(doubleTransformer);
  }
  //
  @override
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0}) {
    final filterByValue = _streamIntParams.filterByValue.name;
    StreamController<DsDataPoint<int>>? streamController;
    if (!_receivers.containsKey(filterByValue)) {
      streamController = StreamController<DsDataPoint<int>>.broadcast();
      _receivers[filterByValue] = streamController;
      _generators[filterByValue] = RandomGenerator<int>(
        _streamIntParams.min, 
        delay: _streamIntParams.delay, 
        min: _streamIntParams.min, 
        max: _streamIntParams.max,
        firstEventDelay: _streamIntParams.firstEventDelay,
      );
      _generators[filterByValue]!.stream.listen((event) {
        _onDataInt(_streamIntParams.filterByValue, event as int);
      });
    } else {
      final receiver = _receivers[filterByValue];
      if (receiver != null) {
        streamController = receiver as StreamController<DsDataPoint<int>>;
      }
    }
    if (streamController != null) {
      _log.debug('[$DsClientFake.stream()] value: $filterByValue,   streamCtrl: $streamController');
      return streamController.stream;
    } else {
      throw Failure.unexpected(
        message: '[$DsClientFake.stream()] streamController can`t be null', 
        stackTrace: StackTrace.current,
      );
    }
  }
  //
  @override
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0}) {
    throw Failure.unexpected(
      message: '[$DsClientFake.streamReal] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Future<ResultF<void>> requestAll() {
    final filterByValue = _requestAllParams.filterByValue.name;
    StreamController<DsDataPoint<double>>? streamController;
    if (!_receivers.containsKey(filterByValue)) {
      streamController = StreamController<DsDataPoint<double>>.broadcast();
      _receivers[filterByValue] = streamController;
      _generators[filterByValue] = RequestedGenerator(
        _requestAllParams.min, 
        delay: _requestAllParams.delay, 
        min: _requestAllParams.min, 
        max: _requestAllParams.max,
      );
      _generators[filterByValue]!.stream.listen((event) {
        _onDataDouble(_requestAllParams.filterByValue, event as double);
      });
    } else {
      final receiver = _receivers[filterByValue];
      if (receiver != null) {
        streamController = receiver as StreamController<DsDataPoint<double>>;
      }
    }
    if (streamController != null) {
      _log.debug('[$DsClientFake.stream()] value: $filterByValue,   streamCtrl: $streamController');
      // ignore: void_checks
      return Future.value(Ok(streamController.stream));
    } else {
      throw Failure.unexpected(
        message: '[$DsClientFake.stream()] streamController can`t be null', 
        stackTrace: StackTrace.current,
      );
    }
  }
  //
  @override
  bool isConnected() => _isConnected;
  //
  @override
  int get subscriptionsCount => _receivers.values.length;
  ///
  /// поток данных отфильтрованный 
  /// по имени точки данных DsDataPoint<double>
  Stream<DsDataPoint<double>> _streamEmulated(
    DsPointName filterByValue, {
    int delay = 100, 
    double min = 0, 
    double max = 100, 
    int firstEventDelay = 0,
  }) {
    StreamController<DsDataPoint<double>>? streamController;
    if (!_receivers.containsKey(filterByValue)) {
      streamController = StreamController<DsDataPoint<double>>.broadcast();
      _receivers[filterByValue.name] = streamController;
      _generators[filterByValue.name] = RandomGenerator<double>(
        min, 
        delay: delay, 
        min: min, 
        max: max,
        firstEventDelay: firstEventDelay,
      );
      _generators[filterByValue]!.stream.listen((event) {
        _onDataDouble(filterByValue, event as double);
      });
    } else {
      final receiver = _receivers[filterByValue];
      if (receiver != null) {
        streamController = receiver as StreamController<DsDataPoint<double>>;
      }
    }
    if (streamController != null) {
      _log.debug('[$DsClientFake._streamEmulated()] value: $filterByValue,   streamCtrl: $streamController');
      return streamController.stream;
    } else {
      throw Failure.unexpected(
        message: '[$DsClientFake._streamEmulated()] streamController can`t be null', 
        stackTrace: StackTrace.current,
      );
    }
  }
  ///
  void _handleToTStreamData<T>(DsDataPoint data, EventSink sink) {
    if (T is int) {
      sink.add(
        DsDataPoint<int>(
          type: data.type, 
          name: data.name, 
          value: int.parse('${data.value}'),
          status: data.status,
          cot: data.cot,
          timestamp: data.timestamp,
        ),
      );
    } else if (T is bool) {
      sink.add(
        DsDataPoint<bool>(
          type: data.type, 
          name: data.name, 
          value: int.parse('${data.value}') > 0,
          status: data.status,
          cot: data.cot,
          timestamp: data.timestamp,
        ),
      );
    } else if (T is double) {
      sink.add(
        DsDataPoint<double>(
          type: data.type, 
          name: data.name, 
          value: double.parse('${data.value}'),
          status: data.status,
          cot: data.cot,
          timestamp: data.timestamp,
        ),
      );
    } else {
      sink.addError(
        Failure.unexpected(
          message: 'Ошибка в методе _handleToTStreamData класса $DsClientFake: usupported data type',
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  void _handleToBoolStreamData(DsDataPoint data, EventSink sink) {
    if (data.value == 0) {
      sink.add(
        DsDataPoint<bool>(
          type: DsDataType.bool, 
          name: DsPointName('/'), 
          value: false, 
          status: DsStatus.ok,
          cot: data.cot,
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
    } else if (data.value == 1) {
      sink.add(
        DsDataPoint<bool>(
          type: DsDataType.bool, 
          name: DsPointName('/'), 
          value: true, 
          status: DsStatus.ok,
          cot: data.cot,
          timestamp: DateTime.now().toIso8601String(),
        ),
      );
    } else {
      sink.addError(
        Failure.unexpected(
          message: 'Ошибка в методе _handleToBoolStreamData класса $DsClientFake:\ninput data must be 0 or 1, but $data given',
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  void _onDataDouble(DsPointName name, double event) {
    final point = DsDataPoint(
      type: DsDataType.real,
      name: name, //'AnalogSensors.Winch.EncoderBR1',
      value: event,
      status: DsStatus.ok,
      cot: DsCot.inf,
      timestamp: DateTime.now().toIso8601String(),
    );
    if (_receivers.keys.contains(point.name.name)) {
      // print('decodedEvent: $dataPint');
      _receivers[name]!.add(point);
    }
  }
  ///
  void _onDataInt(DsPointName name, int event) {
    final point = DsDataPoint(
      type: DsDataType.integer,
      name: name, //'AnalogSensors.Winch.EncoderBR1',
      value: event,
      cot: DsCot.inf,
      status: DsStatus.ok,
      timestamp: DateTime.now().toIso8601String(),
    );
    if (_receivers.keys.contains(point.name.name)) {
      // print('decodedEvent: $dataPint');
      _receivers[name]!.add(point);
    }
  }
}

///
abstract class CustomDataGenerator<T> {
  Stream<T> get stream;
}

///
class RandomGenerator<T> extends CustomDataGenerator<T> {
  // static const _debug = true;
  late StreamController<T> _controller;
  bool _cancel = false;
  bool _active = false;
  double _value = 0;
  final int _delay;
  final double _min;
  final double _max;
  final int _firstEventDelay;
  double _increment = 1;
  ///
  RandomGenerator(
    double initValue, {
    int delay = 50,
    double min = 0,
    double max = 100,
    int firstEventDelay = 0,
    }
  ) :
    _value = initValue,
    _delay = delay,
    _min = min,
    _max = max,
    _firstEventDelay = firstEventDelay
  {
    _controller = StreamController.broadcast(
      onListen: () {
        if (!_active) {
          _run();
        }      
      },
    );
  }
  ///
  @override
  Stream<T> get stream => _controller.stream;
  ///
  void _run() {
    _active = true;
    Future(() async {
      await Future.delayed(Duration(milliseconds: _firstEventDelay));
      while (!_cancel) {
        if (_value <= _min) {
          _increment = 1;
        }
        if (_value >= _max) {
          _increment = -1;
        }
        _value = _value + _increment;
        if (T == int) {
          _controller.add(_value.toInt() as T);
        } else if (T == double) {
          _controller.add(_value as T);
        }
        await Future.delayed(Duration(milliseconds: _delay));
      }
      _active = false;
    });
  }
  void cancel() {
    _cancel = true;
  }
}

///
class RequestedGenerator extends CustomDataGenerator<double> {
  late StreamController<double> _controller;
  bool _active = false;
  double _value = 0;
  final int _delay;
  final double _min;
  final double _max;
  ///
  RequestedGenerator(
    double initValue, {
      int delay = 50,
      double min = 0,
      double max = 100,
    }
  ) :
    _value = initValue,
    _delay = delay,
    _min = min,
    _max = max
  {
    _controller = StreamController.broadcast(
      onListen: () {
        if (!_active) {
          _run();
        }      
      },
    );
  }
  ///
  @override
  Stream<double> get stream => _controller.stream;
  ///
  void _run() {
    _active = true;
    Future.delayed(Duration(milliseconds: _delay))
      .then((value) {
        _value = Random(DateTime.now().millisecond).nextDouble() * (_max - _min) + _min;
        _controller.add(_value);
      });
  }
}
