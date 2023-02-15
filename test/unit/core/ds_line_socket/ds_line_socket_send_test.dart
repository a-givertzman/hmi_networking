import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/hmi_networking.dart';


void main() {
  Log.initialize();
  const log = Log('JdsLine send test');
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

      test('send', () async {
        lineSocketSubscription = lineSocket.stream.listen((event) {
          return;
        });
        final clientSocket = await socketServer.first;
        await Future.delayed(const Duration(milliseconds: 100));
        
        final sendableData = {
          10: utf8.encode('test1'), 
          11: utf8.encode('test2'), 
          12: utf8.encode('test3'), 
          13: utf8.encode('test4'),
          14: utf8.encode('test4'),
          15: utf8.encode('test4'),
        };
          
        String received = '';
        clientSocket.listen((event) {      
          received += utf8.decode(event);
        });
        
        String sending = '';
        for (final event in sendableData.values) {
          sending += utf8.decode(event);
          await lineSocket.send(event);
        }
        await Future.delayed(const Duration(milliseconds: 1500));
        log.debug('received: $received');
        expect(received, sending);
        received = '';
        sending = '';

        for (final entry in sendableData.entries) {
          sending += utf8.decode(entry.value);
          log.debug('sending: ${utf8.decode(entry.value)}');
          final result = await lineSocket.send(entry.value);
          log.debug('result: $result');
          expect(result.hasData, true);
          await Future.delayed(Duration(milliseconds: entry.key));
        }
        await Future.delayed(const Duration(milliseconds: 1000));
        log.debug('received: $received');
        expect(received, sending);
      });
    },
  );
}