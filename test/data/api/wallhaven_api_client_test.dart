import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/api/wallhaven_api_client.dart';
import 'package:haven/data/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('WallhavenApiClient', () {
    late http.Client httpClient;
    late WallhavenApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = WallhavenApiClient(httpClient: httpClient);
    });

    group('headers', () {
      test('sends X-API-Key when key is provided, omits when null or empty',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"data": []}');
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        await apiClient.searchWallpapers(
          const WallpaperQuery(),
          apiKey: 'test-key',
        );

        final capturedWithKey = verify(
          () => httpClient.get(any(), headers: captureAny(named: 'headers')),
        ).captured.first as Map<String, String>;
        expect(capturedWithKey['X-API-Key'], 'test-key');

        await apiClient.searchWallpapers(
          const WallpaperQuery(),
          apiKey: null,
        );

        final capturedWithoutKey = verify(
          () => httpClient.get(any(), headers: captureAny(named: 'headers')),
        ).captured.first as Map<String, String>;
        expect(capturedWithoutKey.containsKey('X-API-Key'), isFalse);
      });
    });

    group('searchWallpapers', () {
      test('throws WallhavenRateLimitFailure on 429', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(429);
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        expect(
          () => apiClient.searchWallpapers(const WallpaperQuery()),
          throwsA(isA<WallhavenRateLimitFailure>()),
        );
      });

      test('throws WallhavenNotFoundFailure when body lacks data key', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"error": "no data"}');
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        expect(
          () => apiClient.searchWallpapers(const WallpaperQuery()),
          throwsA(isA<WallhavenNotFoundFailure>()),
        );
      });

      test('returns WallpaperList against wallhaven_search.json fixture',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(fixture('wallhaven_search.json'));
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        final list = await apiClient.searchWallpapers(const WallpaperQuery());
        expect(list.data.length, 24);
        expect(list.data.first.id, 'rqo8km');
        expect(list.meta.currentPage, 1);
      });
    });

    group('getWallpaper', () {
      test('throws WallhavenNotFoundFailure on 404', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        expect(
          () => apiClient.getWallpaper('unknown'),
          throwsA(isA<WallhavenNotFoundFailure>()),
        );
      });

      test('returns unwrapped Wallpaper against wallhaven_info.json fixture',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(fixture('wallhaven_info.json'));
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);

        final wallpaper = await apiClient.getWallpaper('gpg5ql');
        expect(wallpaper, isA<Wallpaper>());
        expect(wallpaper.id, 'gpg5ql');
      });
    });

    group('getUserSettings', () {
      test('throws WallhavenInvalidApiKeyFailure on 404 or 401', () async {
        final response404 = MockResponse();
        when(() => response404.statusCode).thenReturn(404);
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response404);

        await expectLater(
          apiClient.getUserSettings(apiKey: 'bad-key'),
          throwsA(isA<WallhavenInvalidApiKeyFailure>()),
        );

        final response401 = MockResponse();
        when(() => response401.statusCode).thenReturn(401);
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response401);

        await expectLater(
          apiClient.getUserSettings(apiKey: 'bad-key'),
          throwsA(isA<WallhavenInvalidApiKeyFailure>()),
        );
      });

      test('parses json data root correctly against wallhaven_user_settings.json',
          () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(
          () => response.body,
        ).thenReturn(fixture('wallhaven_user_settings.json'));
        when(
          () => httpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => response);
        final settings = await apiClient.getUserSettings(apiKey: 'valid-key');
        expect(settings.perPage, '32');
        expect(settings.thumbSize, 'small');
      });
    });
  });
}
