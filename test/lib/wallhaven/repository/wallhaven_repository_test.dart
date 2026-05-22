// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:haven_app/data/data.dart';
import 'package:mocktail/mocktail.dart';

class MockWallhavenApiClient extends Mock implements WallhavenApiClient {}

class MockWallpaperList extends Mock implements WallpaperList {}

class MockWallpaper extends Mock implements Wallpaper {}

void main() {
  group('WallhavenRepository', () {
    late WallhavenApiClient wallhavenApiClient;
    late WallhavenRepository wallhavenRepository;

    setUp(() {
      wallhavenApiClient = MockWallhavenApiClient();
      wallhavenRepository = WallhavenRepository(
        wallhavenApiClient: wallhavenApiClient,
      );
    });

    group('constructor', () {
      test('instantiates internal wallhaven api client when not injected', () {
        expect(WallhavenRepository(), isNotNull);
      });
    });

    group('getWallpaper', () {
      test('calls wallpaperSearch with correct city', () async {
        try {
          await wallhavenRepository.getWallpaper();
        } catch (_) {}
        verify(() => wallhavenApiClient.wallpaperSearch()).called(1);
      });
    });
  });
}
