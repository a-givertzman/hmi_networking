import 'package:hmi_core/hmi_core.dart';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;
  Pair(this.a, this.b);
}

final testDsCommand = DsCommand(
  dsClass: DsDataClass.commonCmd, 
  type: DsDataType.bool, 
  path: '', 
  name: '', 
  value: 0, 
  status: DsStatus.ok, 
  timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
);

final validCommandsPool = [
  Pair<DsCommand, String>(
    DsCommand(
        dsClass: DsDataClass.commonCmd,
        type: DsDataType.bool, 
        path: 'line1.ied12.db902_panel_controls', 
        name: 'Test.command.bool', 
        value: false, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"bool","path":"line1.ied12.db902_panel_controls","name":"Test.command.bool","value":0,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
        dsClass: DsDataClass.commonCmd,
        type: DsDataType.bool, 
        path: 'line1.ied12.db902_panel_controls', 
        name: 'Test.command.bool', 
        value: true, 
        status: DsStatus.ok, 
        timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"bool","path":"line1.ied12.db902_panel_controls","name":"Test.command.bool","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.integer, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.int',
      value: 32767, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"int","path":"line1.ied12.db902_panel_controls","name":"Test.command.int","value":32767,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.integer, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.int',
      value: -32768, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"int","path":"line1.ied12.db902_panel_controls","name":"Test.command.int","value":-32768,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.dInt, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.dInt',
      value: 4294967295, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"dint","path":"line1.ied12.db902_panel_controls","name":"Test.command.dInt","value":4294967295,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.lInt, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.lInt', 
      value: 9223372036854775807, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"lint","path":"line1.ied12.db902_panel_controls","name":"Test.command.lInt","value":9223372036854775807,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.lInt, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.lInt', 
      value: -9223372036854775808, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"lint","path":"line1.ied12.db902_panel_controls","name":"Test.command.lInt","value":-9223372036854775808,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.uInt, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.uInt', 
      value: 65535, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"uint","path":"line1.ied12.db902_panel_controls","name":"Test.command.uInt","value":65535,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.word, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.word', 
      value: 65535, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"word","path":"line1.ied12.db902_panel_controls","name":"Test.command.word","value":65535,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.real, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.real', 
      value: 3.402823e+38, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"real","path":"line1.ied12.db902_panel_controls","name":"Test.command.real","value":3.402823e+38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.real, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.real', 
      value: -3.402823e+38, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"real","path":"line1.ied12.db902_panel_controls","name":"Test.command.real","value":-3.402823e+38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.real, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.real', 
      value: 1.175495e-38, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"real","path":"line1.ied12.db902_panel_controls","name":"Test.command.real","value":1.175495e-38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsCommand, String>(
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: DsDataType.real, 
      path: 'line1.ied12.db902_panel_controls',
      name: 'Test.command.real', 
      value: -1.175495e-38, 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.parse('2023-01-23T12:22:18.919520'),
    ),
    '{"class":"commonCmd","type":"real","path":"line1.ied12.db902_panel_controls","name":"Test.command.real","value":-1.175495e-38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  // Pair<DsCommand, String>(
  //   DsCommand(
  //     dsClass: DsDataClass.commonCmd,
  //     type: DsDataType.time, 
  //     path: '',
  //     name: '', 
  //     value: 123, 
  //     status: DsStatus.ok, 
  //     timestamp: DsTimeStamp.now(),
  //   ),
  //   '{"class":"commonCmd","type":"int","path":"line1.ied12.db902_panel_controls","name":"Test.command.time","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  // ),
  // Pair<DsCommand, String>(
  //   DsCommand(
  //     dsClass: DsDataClass.commonCmd,
  //     type: DsDataType.dateAndTime, 
  //     path: '',
  //     name: '', 
  //     value: 123, 
  //     status: DsStatus.ok, 
  //     timestamp: DsTimeStamp.now(),
  //   ),
  //   '{"class":"commonCmd","type":"int","path":"line1.ied12.db902_panel_controls","name":"Test.command.dateAndTime","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  // ),
];

/// Commands with all DsDataClass-DsDataType combinations
final invalidCommandsPool = [
  for (final dataType in DsDataType.values)
    DsCommand(
      dsClass: DsDataClass.commonCmd,
      type: dataType, 
      path: '', 
      name: '', 
      value: 'string value', 
      status: DsStatus.ok, 
      timestamp: DsTimeStamp.now(),
    ),
];
