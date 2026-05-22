import 'package:flutter_test/flutter_test.dart';

import 'package:haven_app/data/models/thumbs.dart';

void main() {
  group('Thumbs', () {
    group('fromJson', () {
      test('returns correct Thumbs object', () {
        expect(
          Thumbs.fromJson(const <String, dynamic>{
            'large': 'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
            'original': 'https://th.wallhaven.cc/orig/zy/zyxvqy.jpg',
            'small': 'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
          }),
          isA<Thumbs>()
              .having(
                (w) => w.large,
                'large',
                'https://th.wallhaven.cc/lg/zy/zyxvqy.jpg',
              )
              .having(
                (w) => w.original,
                'original',
                'https://th.wallhaven.cc/orig/zy/zyxvqy.jpg',
              )
              .having(
                (w) => w.small,
                'small',
                'https://th.wallhaven.cc/small/zy/zyxvqy.jpg',
              ),
        );
      });
    });
  });
}
