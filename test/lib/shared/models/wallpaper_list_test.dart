import 'package:flutter_test/flutter_test.dart';

import 'package:haven_app/data/models/models.dart';

void main() {
  group('WallpaperList', () {
    group('fromJson', () {
      test('returns correct WallpaperList object', () {
        expect(
          WallpaperList.fromJson(const <String, dynamic>{
            'data': [
              {
                'id': 'zyxvqy',
                'url': 'https://wallhaven.cc/w/zyxvqy',
                'short_url': 'https://whvn.cc/zyxvqy',
                'views': 99565,
                'favorites': 831,
                'source': 'https://www.pixiv.net/artworks/102234272',
                'purity': 'sfw',
                'category': 'general',
                'dimension_x': 3840,
                'dimension_y': 2244,
                'resolution': '3840x2244',
                'ratio': '1.71',
                'file_size': 2643206,
                'file_type': 'image/jpeg',
                'created_at': '2022-10-26 08:36:31',
                'colors': [
                  '#424153',
                  '#996633',
                  '#000000',
                  '#cc6633',
                  '#ea4c88',
                ],
                'path': 'https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg',
                'thumbs': {
                  'large': 'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
                  'original': 'https://th.wallhaven.cc/orig/zy/zyxvqy.jpg',
                  'small': 'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
                },
              },
            ],
            'meta': {
              'current_page': 1,
              'last_page': 147,
              'per_page': 24,
              'total': 3510,
              'query': null,
              'seed': null,
            },
          }),
          isA<WallpaperList>()
              .having((w) => w.data, 'data', isA<List<Wallpaper>>())
              .having((w) => w.data[0].id, 'id', 'zyxvqy')
              .having(
                (w) => w.data[0].url,
                'url',
                'https://wallhaven.cc/w/zyxvqy',
              )
              .having(
                (w) => w.data[0].shortUrl,
                'short_url',
                'https://whvn.cc/zyxvqy',
              )
              .having((w) => w.data[0].views, 'views', 99565)
              .having((w) => w.data[0].favorites, 'favorites', 831)
              .having(
                (w) => w.data[0].source,
                'source',
                'https://www.pixiv.net/artworks/102234272',
              )
              .having((w) => w.data[0].purity, 'purity', 'sfw')
              .having((w) => w.data[0].category, 'category', 'general')
              .having((w) => w.data[0].dimensionX, 'dimension_x', 3840)
              .having((w) => w.data[0].dimensionY, 'dimension_y', 2244)
              .having((w) => w.data[0].resolution, 'resolution', '3840x2244')
              .having((w) => w.data[0].ratio, 'ratio', '1.71')
              .having((w) => w.data[0].fileSize, 'file_size', 2643206)
              .having((w) => w.data[0].fileType, 'file_type', 'image/jpeg')
              .having(
                (w) => w.data[0].createdAt,
                'created_at',
                '2022-10-26 08:36:31',
              )
              .having((w) => w.data[0].colors, 'colors', [
                '#424153',
                '#996633',
                '#000000',
                '#cc6633',
                '#ea4c88',
              ])
              .having(
                (w) => w.data[0].path,
                'path',
                'https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg',
              )
              .having(
                (w) => w.data[0].thumbs,
                'thumbs',
                isA<Thumbs>()
                    .having(
                      (t) => t.large,
                      'large',
                      'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
                    )
                    .having(
                      (t) => t.original,
                      'original',
                      'https://th.wallhaven.cc/orig/zy/zyxvqy.jpg',
                    )
                    .having(
                      (t) => t.small,
                      'small',
                      'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
                    ),
              )
              .having((w) => w.meta, 'meta', isA<Meta>())
              .having((w) => w.meta.currentPage, 'current_page', 1)
              .having((w) => w.meta.lastPage, 'last_page', 147)
              .having((w) => w.meta.perPage, 'per_page', 24)
              .having((w) => w.meta.total, 'total', 3510)
              .having((w) => w.meta.query, 'query', null)
              .having((w) => w.meta.seed, 'seed', null),
        );
      });
    });
  });
}
