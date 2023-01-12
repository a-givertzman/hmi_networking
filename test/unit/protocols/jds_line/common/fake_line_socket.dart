import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/hmi_networking.dart';

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