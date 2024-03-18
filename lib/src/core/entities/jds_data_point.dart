import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
/// 
/// [DsDataPoint] with json transformation capabilities.
final class JdsDataPoint<T> implements DsDataPoint<T> {
  final DsDataPoint<T> _point;
  /// 
  /// [DsDataPoint] with json transformation capabilities. 
  const JdsDataPoint(this._point);
  /// 
  /// Deserializes [DsDataPoint] from [json].
  // ignore: long-method
  factory JdsDataPoint.fromMap(Map<String,dynamic> json) {
    final type = DsDataType.fromString(json['type'] as String);
    final name = DsPointName(json['name'] as String);
    final value = '${json['value']}';
    final status = DsStatus.fromValue(json['status'] as int);
    final history = json['history'] as int? ?? 0;
    final alarm = json['alarm'] as int? ?? 0;
    final cot = DsCot.fromString(json['cot'] as String);
    final timestamp = json['timestamp'] as String;
    return JdsDataPoint<T>(
      switch(type) {
        DsDataType.bool => DsDataPoint<bool>(
          type: type, 
          name: name, 
          value: int.parse(value) > 0, 
          history: history, 
          alarm: alarm,
          cot: cot,
          status: status, 
          timestamp: timestamp,
        ) as DsDataPoint<T>,
        DsDataType.integer || 
        DsDataType.uInt    || 
        DsDataType.dInt    || 
        DsDataType.word    ||
        DsDataType.lInt    => DsDataPoint<int>(
          type: type, 
          name: name, 
          value: int.parse(value), 
          history: history, 
          alarm: alarm,
          cot: cot,
          status: status, 
          timestamp: timestamp,
        ) as DsDataPoint<T>,
        DsDataType.real => DsDataPoint<double>(
          type: type, 
          name: name, 
          value: double.parse(value), 
          history: history, 
          alarm: alarm,
          cot: cot,
          status: status, 
          timestamp: timestamp,
        ) as DsDataPoint<T>,
        DsDataType.string => DsDataPoint<String>(
          type: type, 
          name: name,
          value: value,
          status: status,
          timestamp: timestamp,
          cot: cot,
        ) as DsDataPoint<T>,
        DsDataType.time || DsDataType.dateAndTime  => throw Failure.convertion(
          message: 'Ошибка в методе $JdsDataPoint.fromJson(): тип $type не поддерживается',
          stackTrace: StackTrace.current,
        ),
      },
    );
  }
  
  /// 
  /// Converts [DsDataPoint] to [Map] eligible to further serialization.
  Map<String, dynamic> toMap() => {
      'type': _point.type.value,
      'name': _point.name.toString(),
      'value': switch(_point.type){
        DsDataType.bool => _point.value as bool  ? 1 : 0,
        DsDataType.integer || 
        DsDataType.uInt    || 
        DsDataType.dInt    || 
        DsDataType.word    || 
        DsDataType.lInt    ||
        DsDataType.real    => _point.value,
        DsDataType.string => _point.value.toString(),
        DsDataType.time || DsDataType.dateAndTime  => throw Failure.convertion(
          message: 'Ошибка в методе $JdsDataPoint.fromJson(): тип ${_point.type} не поддерживается',
          stackTrace: StackTrace.current,
        ),
      }.toString(),
      'status': _point.status.value,
      'alarm': _point.alarm,
      'history': _point.history,
      'cot': _point.cot.toString(),
      'timestamp': _point.timestamp,
  };
  //
  @override
  DsDataType get type => _point.type;
  //
  @override
  DsPointName get name => _point.name;
  //
  @override
  T get value => _point.value;
  //
  @override
  DsStatus get status => _point.status;
  //
  @override
  int get alarm => _point.alarm;
  @override
  DsCot get cot => _point.cot;
  //
  @override
  int get history => _point.history;
  //
  @override
  String get timestamp => _point.timestamp;
  //
  @override
  String toJson() => _point.toJson();
  //
  @override
  String toString() => _point.toString();
  //
  @override
  bool operator ==(Object other) => _point == other;
  //
  @override
  int get hashCode => _point.hashCode;
  //
  @override
  ResultF<DsDataPoint<T>> toResult() => _point.toResult();
}