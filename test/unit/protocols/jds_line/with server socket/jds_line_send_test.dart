import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import '../../../helpers.dart';
import '../../../test_data.dart';

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

  test('JdsLine with ServerSocket send valid commands', () async {
    final receivedCommands = <DsCommand>[];
    final targetCommands = <DsCommand>[];
    lineSubscription = line.stream.listen((event) { print(event); });
    
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    
    clientSocket!.listen((event) {
      receivedCommands.addAll(decodeCommands(event));
    });
    await Future.delayed(const Duration(milliseconds: 100));

    for (final command in validCommandsPool) {
      line.send(command);
      targetCommands.add(command);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    expect(receivedCommands, targetCommands);
  });

  test('JdsLine with ServerSocket send invalid commads', () async {
    final receivedCommands = <DsCommand>[];
    int errorsThrownActual = 0;
    lineSubscription = line.stream.listen((event) { print(event); });
    
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    
    clientSocket!.listen((event) {
      try {
        receivedCommands.addAll(decodeCommands(event));
      } catch(_) {
        errorsThrownActual += 1;
      }
      
    });
    await Future.delayed(const Duration(milliseconds: 100));

    int errorsThrownTarget = 0;
    for (final command in invalidCommandsPool) {
      await line.send(command);
      errorsThrownTarget += 1;
    }
    
    expect(errorsThrownActual, errorsThrownTarget);
    expect(receivedCommands, []);
  });
}