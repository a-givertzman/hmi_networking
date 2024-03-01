import 'package:hmi_core/hmi_core.dart';
/// 
/// [DsDataPoint] with json transformation capabilities.
class JdsDataPoint {
  final DsDataPoint value;
  /// 
  /// [DsDataPoint] with json transformation capabilities. 
  const JdsDataPoint(this.value);
  /// 
  /// Deserializes [DsDataPoint] from [json].
  factory JdsDataPoint.fromJson(Map<String,dynamic> json) => JdsDataPoint(
    DsDataPoint(
      type: DsDataType.fromString(json['type']), 
      name: DsPointName(json['name']), 
      value: json['value'], 
      status: DsStatus.fromValue(json['status']), 
      history: json['history'],
      alarm: json['alarm'],
      timestamp: json['timestamp'],
    ),
  );
  /// 
  /// Serializes [DsDataPoint] to json.
  Map<String, dynamic> toJson() => {
      'type': value.type.value,
      'name': value.name.toString(),
      'value': value.value,
      'status': value.status.value,
      'history': value.history,
      'alarm': value.alarm,
  };
}