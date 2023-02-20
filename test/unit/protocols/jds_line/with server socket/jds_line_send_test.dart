import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../../../helpers.dart';
import '../test_commands_data.dart';

void main() {
  // ignore: no_leading_underscores_for_local_identifiers
  Log.initialize();
  const log = Log('JdsLine send test');
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
    final receivedCommands = <String>[];
    final targetCommands = <String>[];
    lineSubscription = line.stream.listen((event) { log.debug(event); });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    clientSocket!.listen((event) {
      receivedCommands.addAll(
        splitList(event.toList(), Jds.endOfTransmission)
          .map((encodedEvent) => utf8.decode(encodedEvent)),
      );
    });
    await Future.delayed(const Duration(milliseconds: 100));
    for (final pair in validCommandsPool) {
      line.send(pair.a);
      targetCommands.add(pair.b);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    expect(receivedCommands, targetCommands, reason: 'Sent command doesn`t match json tamplate');
  });
  test('JdsLine with ServerSocket send invalid commads', () async {
    final receivedCommands = <Uint8List>[];
    int errorsThrownActual = 0;
    lineSubscription = line.stream.listen((event) { log.debug(event); });
    // Do not remove! `Connection reset by peer` error will be thrown on group run.
    clientSocket = await socketServer.first;
    clientSocket!.listen((event) {
      receivedCommands.add(event);
    });
    await Future.delayed(const Duration(milliseconds: 100));
    int errorsThrownTarget = 0;
    for (final command in invalidCommandsPool) {
      try {
        await line.send(command);
      } catch(_) {
        errorsThrownActual += 1;
      }
      errorsThrownTarget += 1;
    }
    expect(errorsThrownActual, errorsThrownTarget, reason: 'Wrong command doesn`t recognised');
    expect(receivedCommands, [], reason: 'Nothing should be sent, all commands was wrong');
  });
}