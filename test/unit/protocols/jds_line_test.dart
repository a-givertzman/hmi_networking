import 'dart:async';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';

import '../helpers.dart';
import '../test_data.dart';


class FakeLineSocket extends Fake implements LineSocket {
  final Stream<Uint8List> _fakeStream;
  final bool _isConnected;
  final Result<bool> _requestAllResult;
  final Result<bool> _sendResult;

  FakeLineSocket({
    Stream<Uint8List> stream = const Stream.empty(),
    bool isConnected = true, 
    Result<bool> requestAllResult = const Result(data: true),
    Result<bool> sendResult = const Result(data: true),
  }) : _fakeStream = stream,
    _isConnected = isConnected,
    _requestAllResult = requestAllResult,
    _sendResult = sendResult;

  @override
  Stream<Uint8List> get stream => _fakeStream;

  @override
  bool get isConnected => _isConnected;

  @override
  Result<bool> requestAll() => _requestAllResult;

  @override
  Future<Result<bool>> send(List<int> data) => Future.value(_sendResult);

  @override
  Future close() => Future.value(true);
}

void main() {
  group('JdsLine', () {
    late FakeLineSocket socket;
    late JdsLine line;

      test('stream', () async {
        socket = FakeLineSocket(
          stream: Stream.fromFuture(
            Future.delayed(
              const Duration(milliseconds: 100), 
              () => encodeDataPoints(testDataPoints),
            ),
          ),
          isConnected: true,
        );
        line = JdsLine(lineSocket: socket);

        final receivedEvents = <DsDataPoint>[];
        line.stream.listen((event) { receivedEvents.add(event); });

        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(compareDataPointCollections(receivedEvents, testDataPoints), true);
      });

      test('requestAll', () async {
        socket = FakeLineSocket(
          requestAllResult: const Result(data: true),
          sendResult: const Result(data: true),
        );
        line = JdsLine(lineSocket: socket);

        final receivedEvents = <DsDataPoint>[];
        line.stream.listen((event) { receivedEvents.add(event); });

        await Future.delayed(const Duration(milliseconds: 100));
        final result = await line.requestAll();

        await Future.delayed(const Duration(milliseconds: 100));
        expect(result.data, true);
        expect(receivedEvents.every((event) => event.type == DsDataType.bool && event.value == 1), true);
      });

      test('send', () async {
        socket = FakeLineSocket(
          stream: getDelayedEmptyStream(),
          requestAllResult: const Result(data: true),
          sendResult: const Result(data: true),
        );
        line = JdsLine(lineSocket: socket);

        final receivedEvents = <DsDataPoint>[];
        line.stream.listen((event) { receivedEvents.add(event); });

        await Future.delayed(const Duration(milliseconds: 100));
        final result = await line.send(testDsCommand);

        await Future.delayed(const Duration(milliseconds: 100));
        expect(result.data, true);
      });

      test('close', () async {
        socket = FakeLineSocket(
          stream: getDelayedEmptyStream(),
        );
        line = JdsLine(lineSocket: socket);

        final receivedEvents = <DsDataPoint>[];
        line.stream.listen((event) { receivedEvents.add(event); });

        final result = await line.close();

        expect(result, true);
      });
    },
  );

  group('JdsLine with ServerSocket', () {
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

      test('requestAll', () async {
        final receivedEvents = <DsDataPoint>[];
        line.stream.listen((event) { receivedEvents.add(event); });

        // Do not remove! `Connection reset by peer` error will be thrown on group run.
        clientSocket = await socketServer.first;

        await Future.delayed(const Duration(milliseconds: 100));
        final result = await line.requestAll();

        expect(result.data, true);
        expect(
          receivedEvents.every(
            (event) => event.type == DsDataType.bool && event.value == 1,
          ), 
          true,
        );
      });

      test('send', () async {
        final receivedEvents = <DsDataPoint>[];
        lineSubscription = line.stream.listen((event) { receivedEvents.add(event); });
        
        // Do not remove! `Connection reset by peer` error will be thrown on group run.
        clientSocket = await socketServer.first;

        await Future.delayed(const Duration(milliseconds: 100));
        final result = await line.send(testDsCommand);

        expect(result.data, true);
      });

      test('close', () async {
        lineSubscription = line.stream.listen((event) { log(true, 'received: ', event); });
        clientSocket = await socketServer.first;

        await Future.delayed(const Duration(milliseconds: 100));
        await line.close();

        expect(line.isConnected, false);
      });
    },
  );
}