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
        value: false, 
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
        type: DsDataType.real, 
        path: '', 
        name: '', 
        value: 12345.123, 
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

final sourceDataPoints = <String>[
  '{"class": "commonData", "type": "Bool", "path": "/server/line1/ied13/db905_visual_data_hast", "name": "HPA.PistonMaxLimit", "value": 0, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:23.098078"}',
  '{"class": "commonData", "type": "Bool", "path": "/server/line1/ied13/db905_visual_data_hast", "name": "Winch.Hydromotor2Active", "value": 1, "status": 0, "history": 1, "alarm": 0, "timestamp": "2023-01-12 19:33:23.098078"}',
  '{"class": "commonData", "type": "Int", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": -32768, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "Int", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 0, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "Int", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 32767, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "UInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 0, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "UInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 65535, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "Word", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 0, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "Word", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 65535, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "DInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": -2147483648, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "DInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 0, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "DInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 2147483647, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "LInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": -9223372036854775808, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "LInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 0, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "LInt", "path": "/server/line1/ied14/db906_visual_data", "name": "system.db906_visual_data.status", "value": 9223372036854775807, "status": 0, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.149702"}',
  '{"class": "commonData", "type": "Real", "path": "/server/line1/ied11/db899_drive_data_exhibit", "name": "Drive.Speed", "value": 0, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.096339"}',
  '{"class": "commonData", "type": "Real", "path": "/server/line1/ied11/db899_drive_data_exhibit", "name": "Drive.Speed", "value": -3.402823e+38, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.096339"}',
  '{"class": "commonData", "type": "Real", "path": "/server/line1/ied11/db899_drive_data_exhibit", "name": "Drive.Speed", "value": 3.402823e+38, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.096339"}',
  '{"class": "commonData", "type": "Real", "path": "/server/line1/ied11/db899_drive_data_exhibit", "name": "Drive.Speed", "value": 1.175495e-38, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.096339"}',
  '{"class": "commonData", "type": "Real", "path": "/server/line1/ied11/db899_drive_data_exhibit", "name": "Drive.Speed", "value": -1.175495e-38, "status": 10, "history": 0, "alarm": 0, "timestamp": "2023-01-12 19:33:22.096339"}',  
];

final targetDataPoints = <DsDataPoint>[
  DsDataPoint(type: DsDataType.bool, path: '/server/line1/ied13/db905_visual_data_hast', name: 'HPA.PistonMaxLimit', value: false, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:23.098078'),
  DsDataPoint(type: DsDataType.bool, path: '/server/line1/ied13/db905_visual_data_hast', name: 'Winch.Hydromotor2Active', value: true, status: DsStatus.ok, history: 1, alarm: 0, timestamp: '2023-01-12 19:33:23.098078'),
  DsDataPoint(type: DsDataType.integer, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: -32768, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.integer, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 0, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.integer, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 32767, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.uInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 0, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.uInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 65535, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.word, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 0, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.word, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 65535, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.dInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: -2147483648, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.dInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 0, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.dInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 2147483647, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.lInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: -9223372036854775808, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.lInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 0, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),
  DsDataPoint(type: DsDataType.lInt, path: '/server/line1/ied14/db906_visual_data', name: 'system.db906_visual_data.status', value: 9223372036854775807, status: DsStatus.ok, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.149702'),  
  DsDataPoint(type: DsDataType.real, path: '/server/line1/ied11/db899_drive_data_exhibit', name: 'Drive.Speed', value: 0, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.096339'),
  DsDataPoint(type: DsDataType.real, path: '/server/line1/ied11/db899_drive_data_exhibit', name: 'Drive.Speed', value: -3.402823e+38, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.096339'),
  DsDataPoint(type: DsDataType.real, path: '/server/line1/ied11/db899_drive_data_exhibit', name: 'Drive.Speed', value: 3.402823e+38, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.096339'),
  DsDataPoint(type: DsDataType.real, path: '/server/line1/ied11/db899_drive_data_exhibit', name: 'Drive.Speed', value: 1.175495e-38, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.096339'),
  DsDataPoint(type: DsDataType.real, path: '/server/line1/ied11/db899_drive_data_exhibit', name: 'Drive.Speed', value: -1.175495e-38, status: DsStatus.invalid, history: 0, alarm: 0, timestamp: '2023-01-12 19:33:22.096339'),
];


Stream<Uint8List> getDelayedEmptyStream() => Stream.fromFuture(
  Future.delayed(
    const Duration(milliseconds: 100), 
    () => Uint8List(0),
  ),
);