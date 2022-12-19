import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import '../helpers.dart';

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

      test('requestAll', () async {
        final events = <DsDataPoint>[];
        lineSocketSubscription = lineSocket.stream.listen((event) {
          events.add(decodeDataPoints(event).first);
        });

        await Future.delayed(const Duration(milliseconds: 100));

        await lineSocket.requestAll();

        await Future.delayed(const Duration(milliseconds: 100));

        expect(events.every((event) => event.type == DsDataType.bool && event.value == 1), true);
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
        print('received: $received');
        expect(received, sending);
        received = '';
        sending = '';

        for (final entry in sendableData.entries) {
          sending += utf8.decode(entry.value);
          print('sending: ${utf8.decode(entry.value)}');
          final result = await lineSocket.send(entry.value);
          print('result: ${result}');
          expect(result.hasData, true);
          await Future.delayed(Duration(milliseconds: entry.key));
        }
        await Future.delayed(const Duration(milliseconds: 1000));
        print('received: $received');
        expect(received, sending);
      });

      test('close', () async {
        lineSocketSubscription = lineSocket.stream.listen((event) {
          log(true, 'received: ', utf8.decode(event));
        });

        await Future.delayed(const Duration(milliseconds: 1000));
        
        expect(lineSocket.isConnected, true);

        await lineSocket.close();

        /// isConnected = false,
        expect(lineSocket.isConnected, false);
        /// exit from _listenSocket()
        expect(lineSocket.isActive, false);
      });

      test('stream', () async {
        final receivedData = <String>[];
        lineSocketSubscription = lineSocket.stream.listen((event) { receivedData.add(utf8.decode(event)); });
        final clientSocket = await socketServer.first;
        
        await Future.delayed(const Duration(milliseconds: 100));
        
        const sendRepetitions = 3;
        final testMessage = 'test';

        for(var i = 0; i < sendRepetitions; i++) {
          clientSocket.write(testMessage);
          await Future.delayed(const Duration(milliseconds: 100));
        }

        final targetData = List.generate(sendRepetitions, (index) => testMessage);
        // removing connection event
        receivedData.removeAt(0);
        expect(receivedData, targetData);
      });
    },
  );
}