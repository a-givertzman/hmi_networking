import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_cot.dart';
import 'package:hmi_networking/src/protocols/jds/jds_package/jds_data_type.dart';
///
class JdsPackage<T> {
  final JdsDataType type;
  final T value;
  final DsPointName name;
  final DsStatus status;
  final JdsCot cot;
  final DateTime timestamp;
  ///
  const JdsPackage({
    required this.type,
    required this.value,
    required this.name,
    required this.status,
    required this.cot,
    required this.timestamp,
  });
  ///
  factory JdsPackage.fromMap(Map<String, dynamic> map) {
    final type = JdsDataType.fromString(map['type']);
    final value = map['value'];
    return JdsPackage<T>(
      type: JdsDataType.fromString(map['type']),
      value: switch(type) {        
        JdsDataType.bool => int.parse('$value') > 0,
        JdsDataType.int => int.parse('$value'),
        JdsDataType.float => double.parse('$value'),
        JdsDataType.string => '$value',
      } as T,
      name: DsPointName(map['name']),
      status: DsStatus.fromString(map['status']),
      cot: JdsCot.fromString(map['cot']),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
  ///
  Map<String,dynamic> toMap() => {
    'type': type.toString(),
    'value': value,
    'name': name.toString(),
    'status': status.value,
    'cot': cot.toString(),
    'timestamp': timestamp.toString(),
  };
  ///
  ResultF<T> toResult() => switch(cot) {
    JdsCot.reqCon => Ok(value),
    JdsCot.reqErr => Err(
      Failure(
        message: value, 
        stackTrace: 
        StackTrace.current,
      ),
    ),
    _ => Err(
      Failure(
        message: 'JdsPackage<$T>.toResult() | Unsupported result cot: $cot', 
        stackTrace: 
        StackTrace.current,
      ),
    ),
  };
}