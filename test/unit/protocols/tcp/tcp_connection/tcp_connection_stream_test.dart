import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/hmi_networking.dart';

void main() {
  group('TcpConnection .stream', () {
    test('', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 98567);
      final receivcedData = <int>[];
      server.listen((socket) {
        socket.listen((Uint8List batch) => receivcedData.addAll(batch.toList()));
      });
      // final connection = TcpConnection();
    });
  });
}