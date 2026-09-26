import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/models/models.dart';

void main() {
  group('Avatar', () {
    group('fromJson', () {
      test('returns correct Avatar object', () {
        expect(
          Avatar.fromJson(const <String, dynamic>{
            '200px': 'url200',
            '128px': 'url128',
            '32px': 'url32',
            '20px': 'url20',
          }),
          isA<Avatar>()
              .having((a) => a.px200, 'px200', 'url200')
              .having((a) => a.px128, 'px128', 'url128')
              .having((a) => a.px32, 'px32', 'url32')
              .having((a) => a.px20, 'px20', 'url20'),
        );
      });

      test('handles null values by providing default empty strings', () {
        expect(
          Avatar.fromJson(const <String, dynamic>{
            '200px': null,
            '128px': null,
            '32px': null,
            '20px': null,
          }),
          isA<Avatar>()
              .having((a) => a.px200, 'px200', '')
              .having((a) => a.px128, 'px128', '')
              .having((a) => a.px32, 'px32', '')
              .having((a) => a.px20, 'px20', ''),
        );
      });

      test('handles missing keys by providing default empty strings', () {
        expect(
          Avatar.fromJson(const <String, dynamic>{}),
          isA<Avatar>()
              .having((a) => a.px200, 'px200', '')
              .having((a) => a.px128, 'px128', '')
              .having((a) => a.px32, 'px32', '')
              .having((a) => a.px20, 'px20', ''),
        );
      });
    });

    test('fromJson(toJson()) round-trip equality', () {
      const avatar = Avatar(
        px200: 'https://example.com/200.jpg',
        px128: 'https://example.com/128.jpg',
        px32: 'https://example.com/32.jpg',
        px20: 'https://example.com/20.jpg',
      );
      expect(Avatar.fromJson(avatar.toJson()), equals(avatar));
    });
  });
}
