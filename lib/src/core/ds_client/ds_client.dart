import 'dart:async';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
abstract class DsClient {
  ///
  /// текущее состояние подключения к серверу
  bool isConnected();
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  Stream<DsDataPoint<T>> stream<T>(String name);
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)  
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<double>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0});
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  Stream<DsDataPoint> streamMerged(List<String> names);
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  Future<ResultF<void>> send(
    DsDataPoint point,
  );
  ///
  /// Делает запрос на S7 DataServer что бы получить все точки данных
  /// что бы сервер прочитал и прислал значения всех точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  Future<ResultF<void>> requestAll();
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке
  /// В качестве результата Result<bool> получает результат чтения из S7 
  /// данные не ждем, они прийдут в потоке
  Future<ResultF<void>> requestNamed(List<String> names);
  ///
  /// Returns number of live subscriptions 
  int get subscriptionsCount;
}
