import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
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

  test('JdsLine with ServerSocket close', () async {
    lineSubscription = line.stream.listen((event) { log.debug('received: $event'); });
    clientSocket = await socketServer.first;

    await Future.delayed(const Duration(milliseconds: 100));
    await line.close();

    expect(line.isConnected, false);
  });
}