import 'package:hmi_networking/src/protocols/jds/jds_package/jds_data_type.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_access_mode.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_filters.dart';
import 'package:hmi_networking/src/core/jds_service/jds_point_config/ds_point_address.dart';

///
class JdsPointConfig {
  final JdsDataType type;
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
    return JdsPointConfig(
      type: JdsDataType.fromString(map['type']), 
      address: DsPointAddress.fromMap(map['address']),
      alarmClass: map['alarm'],
      comment: map['comment'],
      filters: DsFilters.fromMap(map['filters']),
      history: DsAccessMode.fromString(map['history']),
    );
  }
}