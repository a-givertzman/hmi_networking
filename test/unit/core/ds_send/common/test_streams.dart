import 'dart:async';

import 'package:hmi_core/hmi_core.dart';

import 'test_point_paths.dart';

StreamController<DsDataPoint<int>> buildController({required int timeout}) {
  final controller1 = StreamController<DsDataPoint<int>>();
  controller1.onListen = () {
    Future.delayed(Duration(seconds: timeout), (() {
      controller1.add(DsDataPoint(
          type: DsDataType.integer,
          path: '',
          name: '',
          value: 121,
          status: DsStatus.ok,
          timestamp: DsTimeStamp.now().toString(),
        ));      
    }));
  };
  return controller1;
}

final testStreams = {
  'stream_int_valid_timeout': buildController(timeout: 5).stream,
  'stream_int_exceeded_timeout': buildController(timeout: 11).stream,
  'stream_int': Stream<DsDataPoint<int>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.integer,
      path: '',
      name: '',
      value: 1,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  'stream_bool': Stream<DsDataPoint<bool>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.bool,
      path: '',
      name: '',
      value: true,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  'stream_real': Stream<DsDataPoint<double>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.real,
      path: '',
      name: '',
      value: 1.234,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[int]!.name: Stream<DsDataPoint<int>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.integer,
      path: '',
      name: '',
      value: 2,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[bool]!.name: Stream<DsDataPoint<bool>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.bool,
      path: '',
      name: '',
      value: false,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
  pointPaths[double]!.name: Stream<DsDataPoint<double>>.periodic(
    const Duration(milliseconds: 10),
    (_) => DsDataPoint(
      type: DsDataType.real,
      path: '',
      name: '',
      value: 2.345,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now().toString(),
    ), 
  ),
};