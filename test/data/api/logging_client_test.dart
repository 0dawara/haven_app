import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/api/logging_client.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeBaseRequest extends Fake implements http.BaseRequest {}

void main() {
  group('LoggingClient', () {
    late http.Client innerClient;
    late LoggingClient loggingClient;

    setUpAll(() {
      registerFallbackValue(FakeBaseRequest());
    });

    setUp(() {
      innerClient = MockHttpClient();
      loggingClient = LoggingClient(innerClient);
    });

    test('X-API-Key value is redacted from logs', () async {
      final logs = <String>[];
      final subscription = Logger.root.onRecord.listen((record) {
        logs.add(record.message);
      });
      Logger.root.level = Level.ALL;

      final response = http.StreamedResponse(
        Stream.value(utf8.encode('{}')),
        200,
        headers: {'content-type': 'application/json'},
      );
      when(() => innerClient.send(any())).thenAnswer((_) async => response);

      final request = http.Request('GET', Uri.parse('https://example.com'))
        ..headers['x-api-key'] = 'super-secret-key-123';

      await loggingClient.send(request);

      await subscription.cancel();

      final allLogs = logs.join('\n');
      expect(allLogs.contains('super-secret-key-123'), isFalse);
      expect(allLogs.contains('***'), isTrue);
    });

    test('image/jpeg response with 2 chunks is not buffered and delivered as 2 chunks',
        () async {
      final chunk1 = [1, 2, 3];
      final chunk2 = [4, 5, 6];
      final stream = Stream.fromIterable([chunk1, chunk2]);

      final response = http.StreamedResponse(
        stream,
        200,
        headers: {'content-type': 'image/jpeg'},
      );

      when(() => innerClient.send(any())).thenAnswer((_) async => response);

      final request = http.Request('GET', Uri.parse('https://example.com/wallpaper.jpg'));
      final streamedResponse = await loggingClient.send(request);

      final chunks = await streamedResponse.stream.toList();
      expect(chunks.length, 2);
      expect(chunks[0], chunk1);
      expect(chunks[1], chunk2);
    });
  });
}
