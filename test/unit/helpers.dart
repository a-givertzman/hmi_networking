import 'dart:convert';
import 'dart:typed_data';

import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

Iterable<List<int>> splitList(List<int> data, int separator) sync* {
  int start = 0;
  final length = data.length;
  for (int i = 0; i < length; i++) {
    if (data[i] == separator) {
      final chunk = data.sublist(start, i);
      yield chunk;
      start = i + 1;
    }
  }
  if (start < length) {
    yield data.sublist(start, length);        
  }
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

bool compareWithoutTimestamp(DsDataPoint first, DsDataPoint second) =>
    first.type == second.type
    && first.name == second.name
    && first.value == second.value
    && first.status == second.status
    && first.history == second.history
    && first.alarm == second.alarm;