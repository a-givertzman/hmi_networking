import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../../helpers.dart';

void main() {
  Log.initialize();
  // const log = Log('JdsLine send test');
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
    test('requestAll when isConnected == true', () async {
      final receivedEvents = <String>[];
      const targetEventsStartings = [
        // Status after successful connection
        '{"type":"int","name":"/Local/Local.System.Connection","value":0,"status":0,"history":0,"alarm":0,"cot":"Inf","timestamp":"',
        // Status by requestAll()
        '{"type":"int","name":"/Local/Local.System.Connection","value":0,"status":0,"history":0,"alarm":0,"cot":"Inf","timestamp":"',
      ];
      lineSocketSubscription = lineSocket.stream.listen((event) {
        receivedEvents.addAll(
          splitList(event.toList(), Jds.endOfTransmission)
            .map((encodedEvent) => utf8.decode(encodedEvent)),
        );
      });
      await Future.delayed(const Duration(milliseconds: 100));
      lineSocket.requestAll();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(receivedEvents.length, targetEventsStartings.length);
      for (int i = 0; i < targetEventsStartings.length; i++) {
        expect(receivedEvents[i].startsWith(targetEventsStartings[i]), true);
      }
    });
    test('requestAll when isConnected == false', () async {
      final receivedEvents = <String>[];
      const targetEventsStartings = [
        // Status after successful connection
        '{"type":"int","name":"/Local/Local.System.Connection","value":0,"status":0,"history":0,"alarm":0,"cot":"Inf","timestamp":"',
        // Status after connection loss
        '{"type":"int","name":"/Local/Local.System.Connection","value":10,"status":0,"history":0,"alarm":0,"cot":"Inf","timestamp":"',
        // Status by requestAll()
        '{"type":"int","name":"/Local/Local.System.Connection","value":10,"status":0,"history":0,"alarm":0,"cot":"Inf","timestamp":"',
      ];
      lineSocketSubscription = lineSocket.stream.listen((event) {
        receivedEvents.addAll(
          splitList(event.toList(), Jds.endOfTransmission)
            .map((encodedEvent) => utf8.decode(encodedEvent)),
        );
      });
      final clientSocket = await socketServer.first;
      await clientSocket.close();
      await Future.delayed(const Duration(milliseconds: 100));
      lineSocket.requestAll();
      await Future.delayed(const Duration(milliseconds: 100));
      expect(receivedEvents.length, targetEventsStartings.length);
      for (int i = 0; i < targetEventsStartings.length; i++) {
        expect(receivedEvents[i].startsWith(targetEventsStartings[i]), true);
      }
    });
  });
}