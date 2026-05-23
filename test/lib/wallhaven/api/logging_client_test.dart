import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:haven_app/data/api/logging_client.dart';

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

    test(
      'send calls inner client and allows reading response multiple times',
      () async {
        final responseBody = '{"test": "data"}';
        final response = http.StreamedResponse(
          Stream.value(utf8.encode(responseBody)),
          200,
        );

        when(() => innerClient.send(any())).thenAnswer((_) async => response);

        final streamedResponse = await loggingClient.get(
          Uri.parse('https://example.com'),
        );

        // The LoggingClient already consumed the stream once for logging.
        // Now we (as the consumer) should be able to consume it again.
        // Actually, since LoggingClient returns a NEW StreamedResponse, we are consuming the new one.

        final body = streamedResponse.body;
        expect(body, equals(responseBody));
        expect(streamedResponse.statusCode, equals(200));
      },
    );

    test('handles binary data without crashing', () async {
      final binaryData = [0, 1, 2, 3, 0xFF];
      final response = http.StreamedResponse(Stream.value(binaryData), 200);

      when(() => innerClient.send(any())).thenAnswer((_) async => response);

      final streamedResponse = await loggingClient.get(
        Uri.parse('https://example.com'),
      );

      final bodyBytes = streamedResponse.bodyBytes;
      expect(bodyBytes, equals(binaryData));
    });
  });
}
