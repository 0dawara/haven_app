// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:haven_app/data/models/models.dart';
import 'package:haven_app/data/api/wallhaven_api_client.dart';

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

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(WallhavenApiClient(), isNotNull);
      });
    });

    group('wallpaperSearch', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.wallpaperSearch();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https('wallhaven.cc', '/api/v1/search', {'sorting': 'toplist'}),
          ),
        ).called(1);
      });

      test(
        'throws WallpaperSearchRequestFailure on non-200 response',
        () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(400);
          when(() => httpClient.get(any())).thenAnswer((_) async => response);
          expect(
            () async => apiClient.wallpaperSearch(),
            throwsA(isA<WallpaperSearchRequestFailure>()),
          );
        },
      );

      test('throws WallpaperNotFoundFailure on error response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.wallpaperSearch(),
          throwsA(isA<WallpaperNotFoundFailure>()),
        );
      });

      test('throws WallpaperNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.wallpaperSearch(),
          throwsA(isA<WallpaperNotFoundFailure>()),
        );
      });

      test('returns WallpaperList on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('''
{
    "data": [
        {
            "id": "zyxvqy",
            "url": "https://wallhaven.cc/w/zyxvqy",
            "short_url": "https://whvn.cc/zyxvqy",
            "views": 99565,
            "favorites": 831,
            "source": "https://www.pixiv.net/artworks/102234272",
            "purity": "sfw",
            "category": "general",
            "dimension_x": 3840,
            "dimension_y": 2244,
            "resolution": "3840x2244",
            "ratio": "1.71",
            "file_size": 2643206,
            "file_type": "image/jpeg",
            "created_at": "2022-10-26 08:36:31",
            "colors": [
                "#424153",
                "#996633",
                "#000000",
                "#cc6633",
                "#ea4c88"
            ],
            "path": "https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg",
            "thumbs": {
                "large": "https://th.wallhaven.cc/lg/zy/zyxvqy.jpg",
                "original": "https://th.wallhaven.cc/orig/zy/zyxvqy.jpg",
                "small": "https://th.wallhaven.cc/small/zy/zyxvqy.jpg"
            }
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 1,
        "total": 1,
        "query": null,
        "seed": null
    }
}
''');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.wallpaperSearch();
        expect(
          actual,
          isA<WallpaperList>()
              .having((l) => l.data, 'data', isNotNull)
              .having((l) => l.data[0].id, 'id', 'zyxvqy')
              .having(
                (l) => l.data[0].url,
                'url',
                'https://wallhaven.cc/w/zyxvqy',
              )
              .having(
                (l) => l.data[0].shortUrl,
                'short_url',
                'https://whvn.cc/zyxvqy',
              )
              .having((l) => l.data[0].views, 'views', 99565)
              .having((l) => l.data[0].favorites, 'favorites', 831)
              .having(
                (l) => l.data[0].source,
                'source',
                'https://www.pixiv.net/artworks/102234272',
              )
              .having((l) => l.data[0].purity, 'purity', 'sfw')
              .having((l) => l.data[0].category, 'category', 'general')
              .having((l) => l.data[0].dimensionX, 'dimension_x', 3840)
              .having((l) => l.data[0].dimensionY, 'dimension_y', 2244)
              .having((l) => l.data[0].resolution, 'resolution', '3840x2244')
              .having((l) => l.data[0].ratio, 'ratio', '1.71')
              .having((l) => l.data[0].fileSize, 'file_size', 2643206)
              .having((l) => l.data[0].fileType, 'file_type', 'image/jpeg')
              .having(
                (l) => l.data[0].createdAt,
                'created_at',
                '2022-10-26 08:36:31',
              )
              .having((l) => l.data[0].colors, 'colors', [
                '#424153',
                '#996633',
                '#000000',
                '#cc6633',
                '#ea4c88',
              ])
              .having(
                (l) => l.data[0].path,
                'path',
                'https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg',
              )
              .having(
                (l) => l.data[0].thumbs,
                'thumbs',
                Thumbs.fromJson(const {
                  'large': 'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
                  'original': 'https://th.wallhaven.cc/orig/zy/zyxvqy.jpg',
                  'small': 'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
                }),
              )
              .having((l) => l.meta, 'meta', isA<Meta>())
              .having((l) => l.meta.currentPage, 'currentPage', 1)
              .having((l) => l.meta.lastPage, 'lastPage', 1)
              .having((l) => l.meta.perPage, 'perPage', 1)
              .having((l) => l.meta.total, 'total', 1)
              .having((l) => l.meta.query, 'query', null)
              .having((l) => l.meta.seed, 'seed', null),
        );
      });
    });
  });
}
