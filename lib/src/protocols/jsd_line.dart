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
  static DsDataPoint _dataPointFromJson(Map<String, dynamic> json) {
    // log(_debug, '[$JdsLine._dataPointFromJson] json: $json');
    try {
      return DsDataPoint(
        type: DsDataType.fromString(json['type'] as String),
        path: json['path'] as String,
        name: json['name'] as String,
        value: json['value'],
        status: DsStatus.fromValue(json['status']  as int),
        history: json['history'] as int? ?? 0,
        alarm: json['alarm'] as int? ?? 0,
        timestamp: json['timestamp'] as String,
      );
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
  Future<Result<bool>> send(
    DsCommand dsCommand,
  ) {
    log(_debug, '[$JdsLine.send] dsCommand: $dsCommand');
    List<int> bytes = utf8.encode(dsCommand.toJson());
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
}
