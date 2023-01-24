import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  final stateColors = StateColors(
    error: Color(0x000001), 
    obsolete: Color(0x000002), 
    invalid: Color(0x000003), 
    timeInvalid: Color(0x000004), 
    lowLevel: Color(0x000005), 
    alarmLowLevel: Color(0x000006), 
    highLevel: Color(0x000007),
    alarmHighLevel: Color(0x000008),
    off: Color(0x000009), 
    on: Color(0x000010),
  );
  final sourceDataPoints = [
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: DsDps.off.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: DsDps.on.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: DsDps.transient.value, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: DsDps.undefined, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: 32767, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: 32767, status: DsStatus.obsolete, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: 32767, status: DsStatus.invalid, timestamp: DsTimeStamp.now().toString()),
    DsDataPoint(type: DsDataType.integer, path: '', name: '', value: 32767, status: DsStatus.timeInvalid, timestamp: DsTimeStamp.now().toString()),
  ];
  final targetColors = [
    stateColors.off,
    stateColors.on,
    stateColors.error,
    stateColors.invalid,
    stateColors.invalid,
    stateColors.obsolete,
    stateColors.invalid,
    stateColors.timeInvalid,
  ];
  test('DsDataStreamExtract buildColors', () async {
    final dsDataStreamExtract = DsDataStreamExtract(
      stream: Stream.fromIterable(sourceDataPoints),
      stateColors: stateColors,
    );
    final receivedColors = <Color>[];
    dsDataStreamExtract.stream.listen((event) {
      receivedColors.add(event.color);
    });
    await Future.delayed(Duration(milliseconds: 10));
    expect(receivedColors, targetColors);
  });
}