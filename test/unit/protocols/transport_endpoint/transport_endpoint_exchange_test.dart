import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/src/core/result_new/result.dart';
import 'package:hmi_networking/src/protocols/transport_connection.dart';
import 'package:hmi_networking/src/protocols/transport_endpoint.dart';
import 'package:hmi_networking/src/protocols/transport_protocol.dart';

///
final class _FakeConnection implements TransportConnection {
  final void Function() _onClose;
  final void Function(List<int>) _onAdd;
  final Stream<int> Function() _onStream;
  ///
  _FakeConnection({
    required void Function() onClose, 
    required void Function(List<int>) onAdd, 
    required Stream<int> Function() onStream,
  }) : 
    _onClose = onClose, 
    _onAdd = onAdd,
    _onStream = onStream;
  //
  @override
  void add(List<int> data) => _onAdd(data);
  //
  @override
  void close() => _onClose();
  //
  @override
  Stream<int> get stream => _onStream();
}
///
final class _FakeTransportProtocol implements TransportProtocol {
  final Future<ResultF<TransportConnection>> _establishedConnection;
  //
  _FakeTransportProtocol(Future<ResultF<TransportConnection>> establishedConnection) : 
    _establishedConnection = establishedConnection;
  //
  @override
  Future<ResultF<TransportConnection>> establishConnection() => _establishedConnection;
}

void main() {
  group('TransportEndpoint .exchange(data)', () {
    const dataToSend = [[235, 56], [5687, 789, 456], [234], [123], [1], [2], [3]];
    test('sends and receives bytes correctly', () async {
      final sentBytes = <int>[];
      final serverAnswer = [1, 2, 3];
      final fakeProtocol = _FakeTransportProtocol(
        Future.value(
          Ok(
            _FakeConnection(
              onClose: () {return;}, 
              onAdd: (bytes) => sentBytes.addAll(bytes),
              onStream: () => Stream.fromIterable(serverAnswer),
            ),
          ),
        ),
      );
      final endpoint = TransportEndpoint(
        protocol: fakeProtocol,
      );
      for(int i = 0; i < dataToSend.length; i++) {
        final result = await endpoint.exchange(dataToSend[i]);
        expect(result, isA<Ok>());
        expect((result as Ok<List<int>, Failure>).value, equals(serverAnswer));
        expect(sentBytes, equals(dataToSend[i]));
        sentBytes.clear();
      }
    });
    test('returns Err on error from stream', () async {
      final fakeProtocol = _FakeTransportProtocol(
        Future.value(
          Ok(
            _FakeConnection(
              onClose: () {return;}, 
              onAdd: (_) {return;},
              onStream: () => Stream.error('error'),
            ),
          ),
        ),
      );
      final endpoint = TransportEndpoint(
        protocol: fakeProtocol,
      );
      for(final data in dataToSend) {
        final result = await endpoint.exchange(data);
        expect(result, isA<Err>());
      }
    });
    test('returns Err on connection failure', () async {
      final fakeProtocol = _FakeTransportProtocol(
        Future.value(
          Err(
            Failure(
              message: 'error',
              stackTrace: StackTrace.current,
            ),
          ),
        ),
      );
      final endpoint = TransportEndpoint(
        protocol: fakeProtocol,
      );
      for(final data in dataToSend) {
        final result = await endpoint.exchange(data);
        expect(result, isA<Err>());
      }
    });
  });
}