import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';


void main() {
  group('DsLineSocket with ServerSocket', () {
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

      test('isConnected', () async {
        expect(lineSocket.isConnected, false);

        lineSocketSubscription = lineSocket.stream.listen((event) { 
          return;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        expect(lineSocket.isConnected, true);
      });

      test('!isConnected', () async {
        lineSocketSubscription = lineSocket.stream.listen((event) {
          return;
        });
        final clientSocket = await socketServer.first;
        
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(lineSocket.isConnected, true);

        await socketServer.close();
        await clientSocket.close();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(lineSocket.isConnected, false);
      });
    },
  );
}