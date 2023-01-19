import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import '../../../helpers.dart';

void main() {
  final ip = InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  late JdsLine line;
  StreamSubscription<DsDataPoint>? lineSubscription;
  Socket? clientSocket;

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
    await lineSubscription?.cancel();
    await clientSocket?.close();
    await socketServer.close();
  });

  test('JdsLine with ServerSocket requestAll when isConnected == true', () async {
    final events = <DsDataPoint>[];
    final receivedCommands = <DsCommand>[];
    line.stream.listen((event) { events.add(event); });

    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    clientSocket!.listen(
      (event) => receivedCommands.addAll(decodeCommands(event)));

    await Future.delayed(const Duration(milliseconds: 100));
    await line.requestAll();
    expect(events.length, 2);
    // Status after successful connection
    expect(
      events[0].name == 'Local.System.Connection' && events[0].value == true,
      true,
    );
    // Status by requestAll()
    expect(
      events[1].name == 'Local.System.Connection' && events[1].value == true,
      true,
    );

    // Command sent to server
    final requestCommand = receivedCommands[0];
    expect(
      requestCommand.dsClass == DsDataClass.requestAll 
        && requestCommand.name == '' 
        && requestCommand.path == ''
        && requestCommand.status == DsStatus.ok
        && requestCommand.type == DsDataType.bool
        && requestCommand.value == true,
      true,
    );
  });

  test('JdsLine with ServerSocket requestAll when isConnected == false', () async {
    final events = <DsDataPoint>[];
    final receivedCommands = <DsCommand>[];
    line.stream.listen((event) { events.add(event); });

    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    await Future.delayed(const Duration(milliseconds: 100));
    await clientSocket!.close(); 
    await Future.delayed(const Duration(milliseconds: 100));

    await line.requestAll();

    expect(events.length, 3);
    // Status after successful connection
    expect(
      events[0].name == 'Local.System.Connection' && events[0].value == true,
      true,
    );
    // Status after connection loss
    expect(
      events[1].name == 'Local.System.Connection' && events[1].value == false,
      true,
    );
    // Status by requestAll()
    expect(
      events[2].name == 'Local.System.Connection' && events[2].value == false,
      true,
    );
    // Command sent to server
    expect(
      receivedCommands,
      []
    );
  });
}