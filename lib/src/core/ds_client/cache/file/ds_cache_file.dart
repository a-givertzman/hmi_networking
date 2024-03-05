import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/entities/jds_data_point.dart';

///
/// Reads and writes cache states using json file.
final class DsCacheFile {
  final TextFile _cacheFile;
  ///
  ///  Reads and writes cache states using json [cacheFile].
  const DsCacheFile(TextFile cacheFile) : _cacheFile = cacheFile;
  ///
  /// Write cache state to json file.
  Future<void> write(Map<String, DsDataPoint> cache) {
    final serializedCache = json.encode(
      cache.map((key, value) => MapEntry(
        key, 
        JdsDataPoint(value).toMap(),
      )),
    );
    return _cacheFile.write(serializedCache);
  }
  ///
  /// Read cache state from json file.
  Future<Map<String, DsDataPoint>> read() {
    return JsonMap.fromTextFile(_cacheFile)
      .decoded
      .then(
        (result) => switch(result) {
          Ok(value:final points) => points.map(
            (key, jsonPoint) => MapEntry(
              key,
              JdsDataPoint.fromMap(jsonPoint),
            ),
          ),
          Err() => <String, DsDataPoint>{},
        },
      );
  }
}