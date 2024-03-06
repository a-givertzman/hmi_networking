// ignore_for_file: unused_field
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/ds_client/ds_client.dart';

///
class EmulationParams {
  final String filterByValue;
  final int delay;
  final double min; 
  final double max; 
  final int firstEventDelay;
  ///
  const EmulationParams({
    this.filterByValue = '',
    this.delay = 0,
    this.min = 0,
    this.max = 0,
    this.firstEventDelay = 0,
  });
}

///
/// Методы работающие только в режиме эмуляции для удобства тестирования
class DsClientFake implements DsClient {
  final bool _isConnected;
  final int _subscriptionsCount;
  final EmulationParams _streamParams;
  final EmulationParams _streamMergedParams;
  final EmulationParams _streamBoolParams;
  final EmulationParams _streamIntParams;
  final EmulationParams _streamRealParams;
  final EmulationParams _requestAllParams;
  /// Методы работающие только в режиме эмуляции для удобства тестирования
  const DsClientFake({
    EmulationParams streamParams = const EmulationParams(),
    EmulationParams streamMergedParams = const EmulationParams(),
    EmulationParams streamBoolParams = const EmulationParams(),
    EmulationParams streamIntParams = const EmulationParams(),
    EmulationParams streamRealParams = const EmulationParams(),
    EmulationParams requestAllParams = const EmulationParams(),
    bool isConnected = true,
    int subscriptionsCount = 0,
  }) :
    _streamParams = streamParams, 
    _streamMergedParams = streamMergedParams, 
    _streamBoolParams = streamBoolParams, 
    _streamIntParams = streamIntParams,
    _streamRealParams = streamRealParams,
    _requestAllParams = requestAllParams,
    _isConnected = isConnected,
    _subscriptionsCount = subscriptionsCount;
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) {
    throw Failure.unexpected(
      message: '[$DsClientFake.stream] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  @override
  Stream<DsDataPoint> streamMerged(List<String> names) {
    throw Failure.unexpected(
      message: '[$DsClientFake.streamMergedEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  @override
  Future<ResultF<void>> send(
    DsCommand dsCommand,
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
    throw Failure.unexpected(
      message: '[$DsClientFake.streamBool] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0}) {
    throw Failure.unexpected(
      message: '[$DsClientFake.streamInt] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
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
    throw Failure.unexpected(
      message: '[$DsClientFake.requestAll] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  //
  @override
  bool isConnected() => _isConnected;
  //
  @override
  int get subscriptionsCount => _subscriptionsCount;  
}