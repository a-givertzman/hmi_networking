import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'test_point_paths.dart';
///
StreamController<DsDataPoint<int>> buildController({required int timeout}) {
  final controller1 = StreamController<DsDataPoint<int>>();
  controller1.onListen = () {
    Future.delayed(Duration(seconds: timeout), (() {
      controller1.add(DsDataPoint(
          type: DsDataType.integer,
          name: DsPointName('/'),
          value: 121,
          status: DsStatus.ok,
          cot: DsCot.reqCon,
          timestamp: DsTimeStamp.now().toString(),
        ));      
    }));
  };
  return controller1;
}
///
final testStreams = <String, Stream<DsDataPoint<dynamic>>>{
  'stream_int_valid_timeout': buildController(timeout: 5).stream,
  'stream_int_exceeded_timeout': buildController(timeout: 11).stream,
  'stream_int': Stream<DsDataPoint<int>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.integer,
      name: DsPointName('/'),
      value: 1,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  'stream_bool': Stream<DsDataPoint<bool>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.bool,
      name: DsPointName('/'),
      value: true,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  'stream_real': Stream<DsDataPoint<double>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.real,
      name: DsPointName('/'),
      value: 1.234,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[int]!.name: Stream<DsDataPoint<int>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.integer,
      name: DsPointName('/'),
      value: 2,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[bool]!.name: Stream<DsDataPoint<bool>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.bool,
      name: DsPointName('/'),
      value: false,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[double]!.name: Stream<DsDataPoint<double>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.real,
      name: DsPointName('/'),
      value: 2.345,
      status: DsStatus.ok,
      cot: DsCot.reqCon,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
};