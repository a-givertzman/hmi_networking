import 'package:hmi_core/hmi_core.dart';
import 'data_set.dart';
///
class DataSource {
  final Map<String, DataSet> _dataSets;
  const DataSource(this._dataSets);
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
