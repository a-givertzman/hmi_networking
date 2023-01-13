import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

List<DsDataPoint> decodeDataPoints(Uint8List bytes) {
  return JdsLine.chunks(bytes, Jds.endOfTransmission)
    .map((chunk) => String.fromCharCodes(chunk))
    .where((rawPoint) => rawPoint.isNotEmpty)
    .map((rawPoint) => const JsonCodec().decode(rawPoint) as Map<String, dynamic>)
    .map((jsonEvent) => DsDataPoint(
      type: DsDataType.fromString(jsonEvent['type'] as String),
      path: jsonEvent['path'] as String,
      name: jsonEvent['name'] as String,
      value: jsonEvent['value'],
      status: DsStatus.fromValue(jsonEvent['status']  as int),
      history: jsonEvent['history'] as int? ?? 0,
      alarm: jsonEvent['alarm'] as int? ?? 0,
      timestamp: jsonEvent['timestamp'] as String,
    ))
    .toList();
}

List<DsCommand> decodeCommands(Uint8List bytes) {
  return JdsLine.chunks(bytes, Jds.endOfTransmission)
    .map((chunk) => String.fromCharCodes(chunk))
    .where((rawCommand) => rawCommand.isNotEmpty)
    .map((rawCommand) => DsCommand.fromJson(rawCommand))
    .toList();
}

Uint8List encodeDataPoints(List<String> dataPoints) {
  return Uint8List.fromList(
    dataPoints.map(
      (dataPoint) => utf8.encode(dataPoint)
        .toList()
        ..add(Jds.endOfTransmission),
    )
    .expand((element) => element)
    .toList(),
  );
}


bool compareDataPointCollections(List<DsDataPoint> first, List<DsDataPoint> second) {
  return first.asMap().entries
    .every((entry) => entry.value == second[entry.key]);
}

Completer<T> wrapInCompleter<T>(Future<T> future) {
  final completer = Completer<T>();
  future.then(completer.complete).catchError(completer.completeError);
  return completer;
}