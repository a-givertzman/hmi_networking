import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
///
class FakeLine extends Fake implements CustomProtocolLine {
  final StreamController<DsDataPoint> _streamController;
  ///
  FakeLine({
    required StreamController<DsDataPoint> controller,
  }) : _streamController = controller;
  //
  @override
  Stream<DsDataPoint> get stream => _streamController.stream; 
}

void main() {
  Log.initialize();
  // const log = Log('JdsLine send test');
  final ip = InternetAddress.loopbackIPv4;
  late ServerSocket socketServer;
  late JdsLine line;
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
    await socketServer.close();
  });
  test('DsClientReal with ServerSocket stream', () async {
    final dsClient = DsClientReal(
      line: line,
    );     
    const repetitionsCount = 10;
    const subscriptionsCount = 30;
    final streams = List.generate(
      subscriptionsCount, 
      (index) => const Stream<DsDataPoint<int>>.empty(),
    );
    for(var i = 0; i < repetitionsCount; i++) {
      for(var j = 0; j < subscriptionsCount; j++) {
        streams[j] = dsClient.stream<int>('$j');
        final subscription = streams[j].listen((event) { 
          return;
        });
        await subscription.cancel();
      }
    }
    // remains subscription for '/Local/Local.System.Connection' only
    expect(dsClient.subscriptionsCount, 1);
  });
}
