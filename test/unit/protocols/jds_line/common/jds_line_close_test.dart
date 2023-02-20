import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'empty_stream.dart';
import 'fake_line_socket.dart';

void main() {
  late FakeLineSocket socket;
  late JdsLine line;    
  test('JdsLine close', () async {
    socket = FakeLineSocket(
      stream: getDelayedEmptyStream(),
    );
    line = JdsLine(lineSocket: socket);
    final receivedEvents = <DsDataPoint>[];
    line.stream.listen((event) { receivedEvents.add(event); });
    final result = await line.close();
    expect(result, true);
  });
}