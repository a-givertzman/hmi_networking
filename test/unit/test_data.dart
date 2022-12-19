import 'dart:typed_data';

import 'package:hmi_core/hmi_core.dart';

final testDsCommand = DsCommand(
  dsClass: DsDataClass.commonCmd, 
  type: DsDataType.bool, 
  path: '', 
  name: '', 
  value: 0, 
  status: DsStatus.ok, 
  timestamp: DsTimeStamp.now(),
);

final testDataPoints = <DsDataPoint>[
  DsDataPoint(type: DsDataType.integer, path: 'test', name: 'some.int', value: 1, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
  DsDataPoint(type: DsDataType.bool, path: 'test', name: 'some.bool', value: false, status: DsStatus.obsolete, timestamp: DsTimeStamp.now().toString()),
  DsDataPoint(type: DsDataType.real, path: 'test', name: 'some.double', value: 1.7, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString()),
  DsDataPoint(type: DsDataType.word, path: 'test', name: 'some.word', value: 'abc123', status: DsStatus.timeInvalid, timestamp: DsTimeStamp.now().toString()),
];


Stream<Uint8List> getDelayedEmptyStream() => Stream.fromFuture(
  Future.delayed(
    const Duration(milliseconds: 100), 
    () => Uint8List(0),
  ),
);