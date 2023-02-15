import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/hmi_networking.dart';


Future<void> main() async {
  Log.initialize();
  // const log = Log('JdsLine send test');
  final ip = InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  late DsLineSocket lineSocket;
  StreamSubscription<Uint8List>? lineSocketSubscription;

  socketServer = await ServerSocket.bind(ip, 0);
  lineSocket = DsLineSocket(ip: ip.address, port: socketServer.port);

  tearDown(() async {
    await lineSocketSubscription?.cancel();
    await socketServer.close();
  });

  test('DsLineSocket with ServerSocket stream', () async {
    final receivedData = <String>[];
    final targetData = <String>[];
    lineSocketSubscription = lineSocket.stream.listen((event) { receivedData.add(utf8.decode(event)); });
    final clientSocket = await socketServer.first;
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    const sendRepetitions = 3;
    const testMessage = 'test';

    for(var i = 0; i < sendRepetitions; i++) {
      clientSocket.write(testMessage);
      targetData.add(testMessage);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // removing connection event
    receivedData.removeAt(0);
    expect(receivedData, targetData);
  });
}