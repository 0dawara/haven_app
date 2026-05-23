import 'package:flutter_test/flutter_test.dart';
import 'package:haven_app/data/models/models.dart';

void main() {
  group('Uploader', () {
    group('fromJson', () {
      test('returns correct Uploader object', () {
        expect(
          Uploader.fromJson(const <String, dynamic>{
            'username': 'testuser',
            'group': 'testgroup',
            'avatar': {
              '200px': 'url200',
              '128px': 'url128',
              '32px': 'url32',
              '20px': 'url20',
            },
          }),
          isA<Uploader>()
              .having((u) => u.username, 'username', 'testuser')
              .having((u) => u.group, 'group', 'testgroup')
              .having((u) => u.avatar, 'avatar', isA<Avatar>()),
        );
      });

      test('handles null values by providing default values', () {
        expect(
          Uploader.fromJson(const <String, dynamic>{
            'username': null,
            'group': null,
            'avatar': null,
          }),
          isA<Uploader>()
              .having((u) => u.username, 'username', '')
              .having((u) => u.group, 'group', '')
              .having((u) => u.avatar, 'avatar', Avatar.empty),
        );
      });

      test('handles missing keys by providing default values', () {
        expect(
          Uploader.fromJson(const <String, dynamic>{}),
          isA<Uploader>()
              .having((u) => u.username, 'username', '')
              .having((u) => u.group, 'group', '')
              .having((u) => u.avatar, 'avatar', Avatar.empty),
        );
      });
    });
  });
}
