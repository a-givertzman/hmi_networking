import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/hmi_networking.dart';
///
class FakeLineSocket extends Fake implements LineSocket {
  final Stream<Uint8List> _fakeStream;
  final bool _isConnected;
  final ResultF<void> _requestAllResult;
  final ResultF<void> _sendResult;
  ///
  FakeLineSocket({
    Stream<Uint8List> stream = const Stream.empty(),
    bool isConnected = true, 
    ResultF<void> requestAllResult = const Ok(null),
    ResultF<void> sendResult = const Ok(null),
  }) : _fakeStream = stream,
    _isConnected = isConnected,
    _requestAllResult = requestAllResult,
    _sendResult = sendResult;
  //
  @override
  Stream<Uint8List> get stream => _fakeStream;
  //
  @override
  bool get isConnected => _isConnected;
  //
  @override
  ResultF<void> requestAll() => _requestAllResult;
  //
  @override
  Future<ResultF<void>> send(List<int> data) => Future.value(_sendResult);
  //
  @override
  Future<void> close() => Future.value();
}