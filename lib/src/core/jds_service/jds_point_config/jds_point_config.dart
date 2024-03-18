import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_access_mode.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_filters.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_point_address.dart';

///
class JdsPointConfig {
  final DsDataType type;
  final DsPointAddress address;
  final int? alarmClass;
  final String? comment;
  final DsFilters? filters;
  final DsAccessMode? history;
  ///
  const JdsPointConfig({
    required this.type, 
    required this.address, 
    this.alarmClass, 
    this.comment, 
    this.filters, 
    this.history,
  });
  ///
  factory JdsPointConfig.fromMap(Map<String, dynamic> map) {
    final filters = map['filters'];
    final history = map['history'];
    return JdsPointConfig(
      type: DsDataType.fromString(map['type']), 
      address: DsPointAddress.fromMap(map['address']),
      alarmClass: map['alarm'],
      comment: map['comment'],
      filters: filters != null ? DsFilters.fromMap(filters) : null,
      history: history != null ? DsAccessMode.fromString(history) : null,
    );
  }
  ///
  Map<String, dynamic> toMap() => {
    'type': type.value,
    'address': address.toMap(),
    if(alarmClass != null)
      'alarm': alarmClass,
    if(comment != null)
      'comment': comment,
    if(filters != null)
      'filters': filters?.toMap(),
    if(history != null)
      'history': history.toString(),
  };
}