import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  Log.initialize();
  const log = Log('JdsLine send test');
  final ip = InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  late DsLineSocket lineSocket;
  StreamSubscription<Uint8List>? lineSocketSubscription;
  setUp(() async {
    socketServer = await ServerSocket.bind(ip, 0);
    lineSocket = DsLineSocket(ip: ip.address, port: socketServer.port);
  });
  tearDown(() async {
    await lineSocketSubscription?.cancel();
    await socketServer.close();
  });
  test('DsLineSocket with ServerSocket close', () async {
    lineSocketSubscription = lineSocket.stream.listen((event) {
      log.debug('received: ${utf8.decode(event)}');
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    expect(lineSocket.isConnected, true);
    await lineSocket.close();
    // isConnected = false,
    expect(lineSocket.isConnected, false);
    // exit from _listenSocket()
    expect(lineSocket.isActive, false);
  });
}