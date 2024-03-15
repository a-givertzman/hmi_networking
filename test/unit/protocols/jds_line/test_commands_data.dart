import 'package:hmi_core/hmi_core.dart';
///
class Pair<T1, T2> {
  final T1 a;
  final T2 b;
  Pair(this.a, this.b);
}
///
final testDsCommand = DsDataPoint(
  type: DsDataType.bool, 
  name: DsPointName('/'), 
  value: 0, 
  status: DsStatus.ok, 
  cot: DsCot.req,
  timestamp: '2023-01-23T12:22:18.919520',
);
///
final validCommandsPool = [
  Pair<DsDataPoint, String>(
    DsDataPoint(
        type: DsDataType.bool, 
        name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.bool'), 
        value: false, 
        status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"bool","name":"/line1/ied12/db902_panel_controls/Test.command.bool","value":0,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
        type: DsDataType.bool, 
        name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.bool'), 
        value: true, 
        status: DsStatus.ok, 
        cot: DsCot.inf,
        timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"bool","name":"/line1/ied12/db902_panel_controls/Test.command.bool","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.integer, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.int'),
      value: 32767, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"int","name":"/line1/ied12/db902_panel_controls/Test.command.int","value":32767,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.integer, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.int'),
      value: -32768, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"int","name":"/line1/ied12/db902_panel_controls/Test.command.int","value":-32768,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.dInt, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.dInt'),
      value: 4294967295, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"dint","name":"/line1/ied12/db902_panel_controls/Test.command.dInt","value":4294967295,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.lInt, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.lInt'), 
      value: 9223372036854775807, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"lint","name":"/line1/ied12/db902_panel_controls/Test.command.lInt","value":9223372036854775807,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.lInt, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.lInt'), 
      value: -9223372036854775808, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"lint","name":"/line1/ied12/db902_panel_controls/Test.command.lInt","value":-9223372036854775808,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.uInt, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.uInt'), 
      value: 65535, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"uint","name":"/line1/ied12/db902_panel_controls/Test.command.uInt","value":65535,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.word, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.word'), 
      value: 65535, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"word","name":"/line1/ied12/db902_panel_controls/Test.command.word","value":65535,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.real, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.real'), 
      value: 3.402823e+38, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"real","name":"/line1/ied12/db902_panel_controls/Test.command.real","value":3.402823e+38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.real, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.real'), 
      value: -3.402823e+38, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"real","name":"/line1/ied12/db902_panel_controls/Test.command.real","value":-3.402823e+38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.real, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.real'), 
      value: 1.175495e-38, 
      status: DsStatus.ok, 
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',    ),
    '{"class":"commonCmd","type":"real","name":"/line1/ied12/db902_panel_controls/Test.command.real","value":1.175495e-38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  Pair<DsDataPoint, String>(
    DsDataPoint(
      type: DsDataType.real, 
      name: DsPointName('/line1/ied12/db902_panel_controls/Test.command.real'), 
      value: -1.175495e-38, 
      status: DsStatus.ok,
      cot: DsCot.inf,
      timestamp: '2023-01-23T12:22:18.919520',
    ),
    '{"class":"commonCmd","type":"real","name":"/line1/ied12/db902_panel_controls/Test.command.real","value":-1.175495e-38,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  ),
  // Pair<DsCommand, String>(
  //   DsCommand(
  //     dsClass: DsDataClass.commonCmd,
  //     type: DsDataType.time, 
  //     name: '', 
  //     value: 123, 
  //     status: DsStatus.ok, 
  //     timestamp: DsTimeStamp.now(),
  //   ),
  //   '{"class":"commonCmd","type":"int","name":"/line1/ied12/db902_panel_controls/Test.command.time","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  // ),
  // Pair<DsCommand, String>(
  //   DsCommand(
  //     dsClass: DsDataClass.commonCmd,
  //     type: DsDataType.dateAndTime, 
  //     name: '', 
  //     value: 123, 
  //     status: DsStatus.ok, 
  //     timestamp: DsTimeStamp.now(),
  //   ),
  //   '{"class":"commonCmd","type":"int","name":"/line1/ied12/db902_panel_controls/Test.command.dateAndTime","value":1,"status":0,"timestamp":"2023-01-23T12:22:18.919520"}',
  // ),
];
/// 
/// Commands with all DsDataClass-DsDataType combinations
final invalidCommandsPool = [
  for (final dataType in DsDataType.values)
    DsDataPoint(
      type: dataType, 
      name: DsPointName('/'), 
      value: 'string value', 
      status: DsStatus.ok,
      cot: DsCot.req,
      timestamp: DsTimeStamp.now().toString(),
    ),
];
