import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_networking/src/core/non_repetitive_stream.dart';

void main() {
  group('NonRepetitiveStream .stream', () {
    test('emits only unique values', () async {
      final testData = [
        {
          'source': Stream.fromIterable([true,true,true,true,true,true]),
          'target': [true],
        },
        {
          'source': Stream.fromIterable([true,true,true,false,false,true]),
          'target': [true, false, true],
        },
        {
          'source': Stream.fromIterable([1,0,1,0,1,0]),
          'target': [1,0,1,0,1,0],
        },
        {
          'source': Stream.fromIterable([123,123,4,765,123,123]),
          'target': [123,4,765,123],
        },
        {
          'source': Stream.fromIterable(['a','abc','abc','a','a','a','ab']),
          'target': ['a','abc','a','ab'],
        },
        {
          'source': Stream.fromIterable([null,null,null,1,2,true,null]),
          'target': [null,1,2,true,null],
        },
      ];
      for(final {'source':source as Stream, 'target': target as List} in testData) {
        final testStream = NonRepetitiveStream(stream: source);
        expect(await testStream.stream.toList(), target);
      }
    });
  });
}