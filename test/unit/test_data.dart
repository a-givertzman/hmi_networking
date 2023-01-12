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

final validCommandsPool = [
  for (final dataClass in DsDataClass.values)
    [
  DsCommand(
        dsClass: dataClass,
        type: DsDataType.bool, 
        path: '', 
        name: '', 
        value: 0, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.integer, 
        path: '', 
        name: '', 
        value: 15, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.dInt, 
        path: '', 
        name: '', 
        value: 0, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.lInt, 
        path: '', 
        name: '', 
        value: 0, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.uInt, 
        path: '', 
        name: '', 
        value: 0, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.word, 
        path: '',
        name: '', 
        value: 123, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.time, 
        path: '',
        name: '', 
        value: 123, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.dateAndTime, 
        path: '',
        name: '', 
        value: 123, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
    ]
].expand((commands) => commands).toList();

/// Commands with all DsDataClass-DsDataType combinations
final invalidCommandsPool = [
  for (final dataClass in DsDataClass.values)
    [
      DsCommand(
        dsClass: dataClass,
        type: DsDataType.real, 
        path: '', 
        name: '', 
        value: 12345.123, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.now(),
      ),
    ]
].expand((commands) => commands).toList();

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