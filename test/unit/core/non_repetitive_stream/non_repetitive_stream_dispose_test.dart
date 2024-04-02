import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/core/non_repetitive_stream.dart';

void main() {
  group('NonRepetitiveStream .dispose()', () {
    test('cancels subscription on underlying stream', () async {
      final random = Random();
      bool isSubscribed = false;
      bool isCancelled = false;
      final fakeStream = Stream.periodic(const Duration(milliseconds: 200), (_)=> random.nextBool()).asBroadcastStream(
        onListen: (_) {
          isSubscribed = true;
        },
        onCancel: (_) {
          isCancelled = true;
        },
      );
      final testStream = NonRepetitiveStream(stream: fakeStream);
      expect(isSubscribed, isTrue);
      expect(isCancelled, isFalse);
      await testStream.dispose();
      expect(isCancelled, isTrue);
    });
  });
}