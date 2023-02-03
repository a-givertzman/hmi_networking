import 'package:hmi_core/hmi_core.dart';
import 'data_set.dart';
///
class DataSource {
  // static const DataSource _singleton = DataSource._internal();
  static final Map<String, DataSet> _dataSets = {};
  ///
  static void initialize(Map<String, DataSet> dataSets) {
    _dataSets.clear();
    _dataSets.addAll(dataSets);
  }
  ///
  /// Returns dataset entry by name
  static DataSet<T> dataSet<T>(String name) {
    if (_dataSets.containsKey(name)) {
      final dataSet = _dataSets[name];
        return dataSet! as DataSet<T>;
    }
    throw Failure.dataSource(
      message: 'Ошибка в методе $DataSource.dataSet(): $name - несуществующий DataSet',
      stackTrace: StackTrace.current,
    );
  }
}
