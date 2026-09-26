import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/wallpaper_details/cubit/details_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockWallhavenRepository extends Mock implements WallhavenRepository {}

void main() {
  group('DetailsCubit', () {
    late WallhavenRepository repository;

    const wallpaper = Wallpaper(
      id: 'abc',
      url: 'https://example.com/w/abc',
      shortUrl: 'https://whvn.cc/abc',
      views: 10,
      favorites: 5,
      source: '',
      purity: 'sfw',
      category: 'general',
      dimensionX: 1920,
      dimensionY: 1080,
      resolution: '1920x1080',
      ratio: '1.77',
      fileSize: 1000,
      fileType: 'image/jpeg',
      createdAt: '2023-01-01',
      colors: [],
      path: 'https://example.com/abc.jpg',
      thumbs: Thumbs.empty,
      tags: [],
      uploader: Uploader.empty,
    );

    setUp(() {
      repository = MockWallhavenRepository();
    });

    test('initial state has loading status and null wallpaper', () {
      final cubit = DetailsCubit(repository, id: 'abc');
      expect(cubit.state.status, DetailsStatus.loading);
      expect(cubit.state.wallpaper, isNull);
    });

    blocTest<DetailsCubit, DetailsState>(
      'fetch emits loading then success when repository returns wallpaper',
      build: () {
        when(() => repository.getWallpaper('abc')).thenAnswer((_) async => wallpaper);
        return DetailsCubit(repository, id: 'abc');
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const DetailsState(status: DetailsStatus.loading),
        const DetailsState(status: DetailsStatus.success, wallpaper: wallpaper),
      ],
    );

    blocTest<DetailsCubit, DetailsState>(
      'fetch emits loading then failure when repository throws',
      build: () {
        when(
          () => repository.getWallpaper('abc'),
        ).thenThrow(const WallhavenNotFoundFailure('Not found'));
        return DetailsCubit(repository, id: 'abc');
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const DetailsState(status: DetailsStatus.loading),
        const DetailsState(status: DetailsStatus.failure),
      ],
    );
  });
}
