import 'package:flutter_test/flutter_test.dart';

import 'package:haven_app/data/models/models.dart';

void main() {
  group('Wallpaper', () {
    group('fromJson', () {
      test('returns correct Wallpaper object', () {
        expect(
          Wallpaper.fromJson(const <String, dynamic>{
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
            'colors': ['#424153', '#996633', '#000000', '#cc6633', '#ea4c88'],
            'path': 'https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg',
            'thumbs': {
              'large': 'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
              'original': 'https://th.wallhaven.cc/or/zy/zyxvqy.jpg',
              'small': 'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
            },
          }),
          isA<Wallpaper>()
              .having((w) => w.id, 'id', 'zyxvqy')
              .having((w) => w.url, 'url', 'https://wallhaven.cc/w/zyxvqy')
              .having((w) => w.shortUrl, 'short_url', 'https://whvn.cc/zyxvqy')
              .having((w) => w.views, 'views', 99565)
              .having((w) => w.favorites, 'favorites', 831)
              .having(
                (w) => w.source,
                'source',
                'https://www.pixiv.net/artworks/102234272',
              )
              .having((w) => w.purity, 'purity', 'sfw')
              .having((w) => w.category, 'category', 'general')
              .having((w) => w.dimensionX, 'dimension_x', 3840)
              .having((w) => w.dimensionY, 'dimension_y', 2244)
              .having((w) => w.resolution, 'resolution', '3840x2244')
              .having((w) => w.ratio, 'ratio', '1.71')
              .having((w) => w.fileSize, 'file_size', 2643206)
              .having((w) => w.fileType, 'file_type', 'image/jpeg')
              .having((w) => w.createdAt, 'created_at', '2022-10-26 08:36:31')
              .having((w) => w.colors, 'colors', [
                '#424153',
                '#996633',
                '#000000',
                '#cc6633',
                '#ea4c88',
              ])
              .having(
                (w) => w.path,
                'path',
                'https://w.wallhaven.cc/full/zy/wallhaven-zyxvqy.jpg',
              )
              .having(
                (w) => w.thumbs,
                'thumbs',
                Thumbs.fromJson(const {
                  'large': 'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
                  'original': 'https://th.wallhaven.cc/or/zy/zyxvqy.jpg',
                  'small': 'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
                }),
              ),
        );
      });
    });
  });
}
