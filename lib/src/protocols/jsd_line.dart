import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_networking/src/core/line_socket/line_socket.dart';
import 'package:hmi_networking/src/protocols/custom_protocol_line.dart';
///
class Jds {
  static const endOfTransmission = 4;
}
///
class JdsLine implements CustomProtocolLine {
  static final _log = const Log('JdsLine')..level = LogLevel.info;
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
  // ignore: long-method
  static DsDataPoint _dataPointFromJson(Map<String, dynamic> json) {
    _log.debug('[$JdsLine._dataPointFromJson] json: $json');
    try {
      final dType = DsDataType.fromString(json['type'] as String);
      if (dType == DsDataType.bool) {
        return DsDataPoint<bool>(
          type: dType,
          name: DsPointName('${json['name']}'),
          value: int.parse('${json['value']}') > 0,
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          cot: DsCot.fromString(json['cot']),
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.integer 
              || dType == DsDataType.uInt 
              || dType == DsDataType.dInt 
              || dType == DsDataType.word 
              || dType == DsDataType.lInt) {
        return DsDataPoint<int>(
          type: dType,
          name: DsPointName('${json['name']}'),
          value: int.parse('${json['value']}'),
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          cot: DsCot.fromString(json['cot']),
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.real) {
        return DsDataPoint<double>(
          type: dType,
          name: DsPointName('${json['name']}'),
          value: double.parse('${json['value']}'),
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          cot: DsCot.fromString(json['cot']),
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.real) {
        return DsDataPoint<double>(
          type: dType,
          name: DsPointName('${json['name']}'),
          value: double.parse('${json['value']}'),
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          cot: DsCot.fromString(json['cot']),
          timestamp: json['timestamp'] as String,
        );
      } else if (dType == DsDataType.string) {
        return DsDataPoint<String>(
          type: dType,
          name: DsPointName('${json['name']}'),
          value: '${json['value']}',
          status: DsStatus.fromValue(json['status']  as int),
          history: json['history'] as int? ?? 0,
          alarm: json['alarm'] as int? ?? 0,
          cot: DsCot.fromString(json['cot']),
          timestamp: json['timestamp'] as String,
        );
      } else {
        _throwNotImplementedFailure(dType);
      }
    } catch (error) {
      _log.debug('[$JdsLine.fromJson] error: $error');
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
  static Iterable<List<int>> _chunks(List<int> data, int separator) sync* {
    int start = 0;
    final length = data.length;
    for (int i = 0; i < length; i++) {
      if (data[i] == separator) {
        // log(_debug, '[$JdsLine._dataPointTransformer] data[$i]: ${data[i]}');
        final chunk = data.sublist(start, i);
        // log(_debug, '[$JdsLine._dataPointTransformer] chunk: $chunk');
        _log.debug('[$JdsLine._dataPointTransformer] chunk: ${String.fromCharCodes(chunk)}');
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
      _log.debug('[$JdsLine._dataPointTransformer] data: $data');
      for (final chunck in _chunks(data, Jds.endOfTransmission)) {
        final rawPoint = String.fromCharCodes(chunck);
        if(rawPoint.isNotEmpty) {
          final jsonPoint = const JsonCodec().decode(rawPoint) as Map<String, dynamic>;
          final point = _dataPointFromJson(jsonPoint);
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
  Future<ResultF<void>> send(
    DsDataPoint point,
  ) {
    _log.debug('[$JdsLine.send] point: $point');
    List<int> bytes = utf8.encode(point.toJson());
    return _lineSocket.send([...bytes, Jds.endOfTransmission]);
  }
  //  
  @override
  Future<void> close() => _lineSocket.close();
  //
  @override
  bool get isConnected => _lineSocket.isConnected;
  //
  @override
  Future<ResultF<void>> requestAll() async {
    _lineSocket.requestAll();
    return send(DsDataPoint(
      type: DsDataType.bool,
      name: DsPointName('/App/Jds/Gi'),
      value: true,
      status: DsStatus.ok,
      cot: DsCot.req,
      timestamp: DateTime.now().toUtc().toIso8601String(),
    ));
  }
  ///
  /// converts json string into DsCommand 
  /// dipending on the type stored in the json['type']
  // static DsCommand _dsCommandFromJson(String json) {
  //   // log(true, '[$DataPoint.fromJson] json: $json');
  //   try {
  //     final decoded = const JsonCodec().decode(json) as Map;
  //     final dataType = DsDataType.fromString('${decoded['type']}');
  //     if (dataType == DsDataType.bool) {
  //       return DsCommand<bool>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: (int.parse('${decoded['value']}') > 0),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.integer) {
  //       return DsCommand<int>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: int.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.uInt) {
  //       return DsCommand<int>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: int.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.dInt) {
  //       return DsCommand<int>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: int.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.word) {
  //       return DsCommand<int>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: int.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.lInt) {
  //       return DsCommand<int>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: int.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.real) {
  //       return DsCommand<double>(
  //         dsClass: DsDataClass.fromString('${decoded['class']}'),
  //         type: DsDataType.fromString('${decoded['type']}'),
  //         path: '${decoded['path']}',
  //         name: '${decoded['name']}',
  //         value: double.parse('${decoded['value']}'),
  //         status: DsStatus.fromString('${decoded['status']}'),
  //         timestamp: DsTimeStamp.parse('${decoded['timestamp']}'),
  //       );
  //     } else if (dataType == DsDataType.time) {
  //       _throwNotImplementedFailure(dataType);
  //     } else if (dataType == DsDataType.dateAndTime) {
  //       _throwNotImplementedFailure(dataType);
  //     } else {
  //       _throwNotImplementedFailure(dataType);
  //     }
  //   } catch (error) {
  //     log(true, '[$JdsLine._dsCommandFromJson] error: $error\njson: $json');
  //     // log(ug, '[$DsCommand.fromJson] dataPoint: $dataPoint');
  //     throw Failure.convertion(
  //       message: 'Ошибка в методе $JdsLine._dsCommandFromJson() $error',
  //       stackTrace: StackTrace.current,
  //     );
  //   }
  //   // print('event: $decoded');
  // }
  ///
  /// Converts DsCommand to String in json format.
  /// The `value` should always be numeric, so this method casts bool to int.
  static String _dsCommandToJson(DsCommand dsCommand) {
    final value = dsCommand.value;
    if (value is! bool && value is! num) {
      throw Failure.convertion(
        message: 'Ошибка в методе $JdsLine._dsCommandToJson() Некорректный тип поля value',
        stackTrace: StackTrace.current,
      );
    }
    final dynamic castedValue;
    if (dsCommand.type == DsDataType.bool) {
      if (value is bool) {
        castedValue = value ? 1 : 0;
      } else {
        castedValue = (value > 0) ? 1 : 0;
      }
    } else {
      castedValue = value;
    }
    return json.encode({
      'class': dsCommand.dsClass.value,
      'type': dsCommand.type.value,
      'name': dsCommand.name,
      'value': castedValue,
      'status': dsCommand.status.value,
      'timestamp': dsCommand.timestamp.toString(),
    });
  }
}
