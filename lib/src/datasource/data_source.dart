import 'package:hmi_core/hmi_core.dart';
import 'data_set.dart';
///
class DataSource {
  static final DataSource _singleton = DataSource._internal();
  late Map<String, DataSet> _dataSets;
  ///
  factory DataSource(Map<String, DataSet> dataSets) {
    _singleton._dataSets = dataSets;
    return _singleton;
  }
  ///
  DataSource._internal();
  ///
  DataSet<T> dataSet<T>(String name) {
    if (_dataSets.containsKey(name)) {
      final dataSet = _dataSets[name];
        return dataSet! as DataSet<T>;
    }
    throw Failure.dataSource(
      message: 'Ошибка в методе $runtimeType.dataSet(): $name - несуществующий DataSet',
      stackTrace: StackTrace.current,
    );
  }
}
