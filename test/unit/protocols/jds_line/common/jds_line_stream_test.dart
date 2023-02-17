import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../../../helpers.dart';
import 'test_points_data.dart';
import 'fake_line_socket.dart';

void main() {
  late FakeLineSocket socket;
  late JdsLine line;
  Log.initialize(level: LogLevel.off);
  test('JdsLine stream', () async {
    socket = FakeLineSocket(
      stream: Stream.fromFuture(
        Future.delayed(
          const Duration(milliseconds: 100), 
          () => encodeDataPoints(sourceDataPoints),
        ),
      ),
      isConnected: true,
    );
    line = JdsLine(lineSocket: socket);
    final receivedEvents = <DsDataPoint>[];
    line.stream.listen((event) { receivedEvents.add(event); });
    await Future.delayed(const Duration(milliseconds: 100));
    expect(receivedEvents, targetDataPoints);
  });
}