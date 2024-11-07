import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_entities.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_networking/hmi_networking.dart';
import 'fake_line_socket.dart';

void main() {
  late FakeLineSocket socket;
  late JdsLine line;
  Log.initialize(level: LogLevel.off);
  test('JdsLine requestAll', () async {
    socket = FakeLineSocket(
      requestAllResult: const Ok(null),
      sendResult: const Ok(null),
    );
    line = JdsLine(lineSocket: socket);
    final receivedEvents = <DsDataPoint>[];
    line.stream.listen((event) { receivedEvents.add(event); });
    await Future.delayed(const Duration(milliseconds: 100));
    final result = await line.requestAll();
    await Future.delayed(const Duration(milliseconds: 100));
    expect(result, isA<Ok<void, Failure>>());
    expect(
      receivedEvents.every(
        (event) => event.type == DsDataType.bool 
          && event.value == 1
          && event.name.toString() == 'Local.System.Connection',
        ),
      true,
    );
  });
}