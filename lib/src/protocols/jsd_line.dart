import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/src/core/line_socket.dart';
import 'package:hmi_networking/src/protocols/custom_protocol_line.dart';

class Jds {
  static const endOfTransmission = 4;
}

class JdsLine implements CustomProtocolLine {
  static const _debug = true;
  final LineSocket _lineSocket;
  ///
  /// Реализация протокола связи с сервером DataServer
  /// Посредством json объектов:
  /// {
  ///    type: DSDataType
  ///    path: ""
  ///    name: ""
  ///    value: 1
  ///    status: 0
  ///    history: 0
  ///    alarm: 0            
  ///    timestamp: 2022-12-08T17:11:10.842343
  /// }
  JdsLine({
    required LineSocket lineSocket,
  }) : _lineSocket = lineSocket;
  ///
  /// Parse incoming json string into DsDataPoint
  /// depending on type stored in the json['type'] field
  static DsDataPoint dataPointFromJson(Map<String, dynamic> json) {
    // log(_debug, '[$JdsLine._dataPointFromJson] json: $json');
    try {
      final dType = DsDataType.fromString(json['type'] as String);
      if (dType == DsDataType.bool) {
        return DsDataPoint<bool>(
          type: dType,
          path: json['path'] as String,
          name: json['name'] as String,
          value: int.parse('${json['value']}') > 0,
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.integer 
              || dType == DsDataType.uInt 
              || dType == DsDataType.dInt 
              || dType == DsDataType.word 
              || dType == DsDataType.lInt) {
        return DsDataPoint<int>(
          type: dType,
          path: json['path'] as String,
          name: json['name'] as String,
          value: int.parse('${json['value']}'),
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.real) {
        return DsDataPoint<double>(
          type: dType,
          path: json['path'] as String,
          name: json['name'] as String,
          value: double.parse('${json['value']}'),
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          timestamp: json['timestamp'] as String,
        );
      } else {
        _throwNotImplementedFailure(dType);
      }
    } catch (error) {
      // log(true, '[$DsDataPoint.fromRow] error: $error\nrow: $row');
      // log(ug, '[$DataPoint.fromJson] dataPoint: $dataPoint');
      throw Failure.convertion(
        message: 'Ошибка в методе $JdsLine._dataPointFromJson() $error',
        stackTrace: StackTrace.current,
      );
    }
  }
  ///
  static Never _throwNotImplementedFailure(DsDataType dataType) {
    throw Failure(
      message: 'Convertion for type "$dataType" is not implemented yet', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// parse input list of int (from socket)
  ///  - split list by separator (end of message)
  ///  - returns stream of list of int, each list is single message
  static Iterable<List<int>> chunks(List<int> data, int separator) sync* {
    int start = 0;
    final length = data.length;
    for (int i = 0; i < length; i++) {
      if (data[i] == separator) {
        // log(_debug, '[$JdsLine._dataPointTransformer] data[$i]: ${data[i]}');
        final chunk = data.sublist(start, i);
        // log(_debug, '[$JdsLine._dataPointTransformer] chunk: $chunk');
        // log(_debug, '[$JdsLine._dataPointTransformer] chunk: ${String.fromCharCodes(chunk)}');
        yield chunk;
        start = i + 1;
      }
    }
    if (start < length) {
      yield data.sublist(start, length);        
    }
  }
  ///
  static final _dataPointTransformer = StreamTransformer<Uint8List, DsDataPoint>.fromHandlers(
    handleData: (data, sink) {
      // log(_debug, '[$JdsLine._dataPointTransformer] data: $data');
      for (final chunck in chunks(data, Jds.endOfTransmission)) {
        final rawPoint = String.fromCharCodes(chunck);
        if(rawPoint.isNotEmpty) {
          final jsonPoint = const JsonCodec().decode(rawPoint) as Map<String, dynamic>;
          final point = dataPointFromJson(jsonPoint);
          sink.add(point);
        }
      }
    },
  );
  //
  @override
  Stream<DsDataPoint> get stream => _lineSocket.stream.transform(_dataPointTransformer);
  //
  @override
  Future<Result<bool>> send(
    DsCommand dsCommand,
  ) {
    log(_debug, '[$JdsLine.send] dsCommand: $dsCommand');
    List<int> bytes = utf8.encode(dsCommandToJson(dsCommand));
    return _lineSocket.send([...bytes]..add(Jds.endOfTransmission));
  }
  //  
  @override
  Future close() => _lineSocket.close();
  //
  @override
  bool get isConnected => _lineSocket.isConnected;
  //
  @override
  Future<Result<bool>> requestAll() {
    _lineSocket.requestAll();
    return send(DsCommand(
      dsClass: DsDataClass.requestAll,
      type: DsDataType.bool,
      path: '',
      name: '',
      value: 1,
      status: DsStatus.ok,
      timestamp: DsTimeStamp.now(),
    ));
  }
  ///
  /// converts json string into DsCommand 
  /// dipending on the type stored in the json['type']
  static DsCommand dsCommandFromJson(String json) {
    // log(true, '[$DataPoint.fromJson] json: $json');
    try {
      final decoded = const JsonCodec().decode(json) as Map;
      final dataType = DsDataType.fromString('${decoded['type']}');
      if (dataType == DsDataType.bool) {
        return DsCommand<bool>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: (int.parse('${decoded['value']}') > 0),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.integer) {
        return DsCommand<int>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: int.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.uInt) {
        return DsCommand<int>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: int.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.dInt) {
        return DsCommand<int>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: int.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.word) {
        return DsCommand<int>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: int.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.lInt) {
        return DsCommand<int>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: int.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.real) {
        return DsCommand<double>(
          dsClass: DsDataClass.fromString('${decoded['class']}'),
          type: DsDataType.fromString('${decoded['type']}'),
          path: '${decoded['path']}',
          name: '${decoded['name']}',
          value: double.parse('${decoded['value']}'),
          status: DsStatus.fromString('${decoded['status']}'),
          timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
        );
      } else if (dataType == DsDataType.time) {
        _throwNotImplementedFailure(dataType);
      } else if (dataType == DsDataType.dateAndTime) {
        _throwNotImplementedFailure(dataType);
      } else {
        _throwNotImplementedFailure(dataType);
      }
    } catch (error) {
      log(true, '[$DsCommand.fromJson] error: $error\njson: $json');
      // log(ug, '[$DsCommand.fromJson] dataPoint: $dataPoint');
      throw Failure.convertion(
        message: 'Ошибка в методе $DsCommand.fromJson() $error',
        stackTrace: StackTrace.current,
      );
    }
    // print('event: $decoded');
  }
  ///
  /// Converts DsCommand to String in json format.
  /// The `value` should always be numeric, so this method casts bool to int.
  static String dsCommandToJson(DsCommand dsCommand) {
    final value = dsCommand.value;
    if (!(value is bool) && !(value is num)) {
      throw Failure.convertion(
        message: 'Ошибка в методе $JdsLine.dsCommandToJson() Некорректный тип поля value',
        stackTrace: StackTrace.current,
      );
    }
    final dynamic castedValue;
    if (dsCommand.type == DsDataType.bool && value is bool) {
      castedValue = value ? 1 : 0;
    } else {
      castedValue = value;
    }
    return json.encode({
      'class': dsCommand.dsClass.value,
      'type': dsCommand.type.value,
      'path': dsCommand.path,
      'name': dsCommand.name,
      'value': castedValue,
      'status': dsCommand.status.value,
      'timestamp': dsCommand.timestamp.toString(),
    });
  }
}
