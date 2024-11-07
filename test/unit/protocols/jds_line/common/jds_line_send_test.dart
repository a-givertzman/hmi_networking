import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/hmi_networking.dart';
import '../test_commands_data.dart';
import 'empty_stream.dart';
import 'fake_line_socket.dart';

void main() {
  late FakeLineSocket socket;
  late JdsLine line;
  Log.initialize(level: LogLevel.off);
  test('JdsLine send', () async {
    socket = FakeLineSocket(
      stream: getDelayedEmptyStream(),
      requestAllResult: const Ok(null),
      sendResult: const Ok(null),
    );
    line = JdsLine(lineSocket: socket);
    final receivedEvents = <DsDataPoint>[];
    line.stream.listen((event) { receivedEvents.add(event); });
    await Future.delayed(const Duration(milliseconds: 100));
    final result = await line.send(testDsCommand);
    await Future.delayed(const Duration(milliseconds: 100));
    expect(result, isA<Ok<void, Failure>>());
  });
}