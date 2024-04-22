import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../../../helpers.dart';

void main() {
  Log.initialize();
  final ip = InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  late JdsLine line;
  // StreamSubscription<DsDataPoint>? lineSubscription;
  Socket? clientSocket;
  // Points that should have been received after request all command sent
  final targetDataPoints = {
    'Local.System.Connection established': DsDataPoint(type: DsDataType.integer, name: DsPointName("/Local/Local.System.Connection"), value: 0, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
    'Local.System.Connection lost': DsDataPoint(type: DsDataType.integer, name: DsPointName("/Local/Local.System.Connection"), value: 10, status: DsStatus.ok, timestamp: DsTimeStamp.now().toString(), cot: DsCot.inf),
  };
  setUp(() async {
    socketServer = await ServerSocket.bind(ip, 0);
    line = JdsLine(
      lineSocket: DsLineSocket(
        ip: ip.address, 
        port: socketServer.port,
      ),
    );
  });
  tearDown(() async {
    // await lineSubscription?.cancel();
    await clientSocket?.close();
    await socketServer.close();
  });
  test('JdsLine with ServerSocket requestAll when isConnected == true | Check received status data point', () async {
    final receivedDataPoints = <DsDataPoint>[];
    line.stream.listen((event) { 
      receivedDataPoints.add(event); 
    });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    await Future.delayed(const Duration(milliseconds: 100));
    await line.requestAll();
    await Future.delayed(const Duration(milliseconds: 100)); 
    expect(receivedDataPoints.length, 2, reason: 'From JdsLine receaved wrong count of satatus data points');
    for (int i = 0; i < targetDataPoints.length; i++) {
      expect(
        compareWithoutTimestamp(receivedDataPoints[i], targetDataPoints['Local.System.Connection established']!),
        true,
        reason: 'Line generated wrong status data points',
      );
    }
  });
  test('JdsLine with ServerSocket requestAll when isConnected == true | Check sent commands', () async {
    final receivedCommands = <String>[];
    const targetCommandsStartings = [
      // Command sent to server
      //'{"type":"bool","name":"/App/Jds/Gi","value":true,"status":0,"history":0,"alarm":0,"cot":"Req","timestamp":"',
    ];
    line.stream.listen((event) { return; });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    clientSocket!.listen(
      (event) => receivedCommands.addAll(
        splitList(event.toList(), Jds.endOfTransmission)
          .map((encodedEvent) => utf8.decode(encodedEvent)),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    await line.requestAll();
    await Future.delayed(const Duration(milliseconds: 100)); 
    expect(receivedCommands.length, targetCommandsStartings.length);
    for (int i = 0; i < targetCommandsStartings.length; i++) {
      expect(
        receivedCommands[i],
        startsWith(targetCommandsStartings[i]),
        reason: 'Sent command doesn`t match json template',
      );
    }
  });
  test('JdsLine with ServerSocket requestAll when isConnected == false | Check received status data point', () async {
    final receivedDataPoints = <DsDataPoint>[];
    line.stream.listen((event) { 
      receivedDataPoints.add(event);
    });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    await clientSocket!.close();
    await socketServer.close();
    await Future.delayed(const Duration(milliseconds: 100)); 
    await line.requestAll();
    await Future.delayed(const Duration(milliseconds: 100)); 
    expect(receivedDataPoints.length, 3);
    expect(
        compareWithoutTimestamp(receivedDataPoints[0], targetDataPoints['Local.System.Connection established']!),
        true,
        reason: 'Line generated wrong status data points: Connection established status is not found',
    );
    for (int i = 1; i < targetDataPoints.length; i++) {
      expect(
        compareWithoutTimestamp(receivedDataPoints[i], targetDataPoints['Local.System.Connection lost']!),
        true,
        reason: 'Line generated wrong status data points: Connection lost status is not found',
      );
    }
  });
  test('JdsLine with ServerSocket requestAll when isConnected == false | Check sent commands', () async {
    final receivedCommands = <String>[];
    line.stream.listen((_) { return; });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    clientSocket!.listen(
      (event) => receivedCommands.addAll(
        splitList(event.toList(), Jds.endOfTransmission)
          .map((encodedEvent) => utf8.decode(encodedEvent)),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 100)); 
    await clientSocket!.close();
    await socketServer.close();
    await Future.delayed(const Duration(milliseconds: 100)); 
    await line.requestAll();
    await Future.delayed(const Duration(milliseconds: 100));
    expect(receivedCommands.length, 0);
  });
}