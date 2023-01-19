import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import '../../helpers.dart';

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

      test('requestAll when isConnected == true', () async {
        final events = <DsDataPoint>[];
        lineSocketSubscription = lineSocket.stream.listen((event) {
          events.addAll(decodeDataPoints(event));
        });
        await Future.delayed(const Duration(milliseconds: 100));
        lineSocket.requestAll();
        await Future.delayed(const Duration(milliseconds: 100));

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
      });

      test('requestAll when isConnected == false', () async {
        final events = <DsDataPoint>[];
        lineSocketSubscription = lineSocket.stream.listen((event) {
          events.addAll(decodeDataPoints(event));
        });
        final clientSocket = await socketServer.first;
        await clientSocket.close();
        await Future.delayed(const Duration(milliseconds: 100));
        lineSocket.requestAll();
        await Future.delayed(const Duration(milliseconds: 100));

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
      });
    },
  );
}