import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class MockWallhavenRepository extends Mock implements WallhavenRepository {}

void main() {
  initHydratedStorage();

  setUpAll(() {
    registerFallbackValue(const WallpaperQuery());
  });

  group('SearchCubit', () {
    late WallhavenRepository repository;

    setUp(() {
      repository = MockWallhavenRepository();
      when(() => repository.hasApiKey).thenReturn(false);
      when(
        () => repository.searchWallpapers(any()),
      ).thenAnswer((_) async => WallpaperList.empty);
    });

    test('initial state has default query and status initial', () {
      final cubit = SearchCubit(repository);
      expect(cubit.state.status, SearchStatus.initial);
      expect(cubit.state.wallQuery, const WallpaperQuery());
    });

    blocTest<SearchCubit, SearchState>(
      'no-arg fetchWallpaper() sends state.wallQuery to repository',
      build: () => SearchCubit(repository),
      act: (cubit) => cubit.fetchWallpaper(),
      verify: (_) {
        verify(
          () => repository.searchWallpapers(const WallpaperQuery()),
        ).called(1);
      },
    );

    test('latest wins: first fetch resolving after second leaves second in state',
        () async {
      final completer1 = Completer<WallpaperList>();
      final completer2 = Completer<WallpaperList>();

      when(
        () => repository.searchWallpapers(const WallpaperQuery(query: 'first')),
      ).thenAnswer((_) => completer1.future);
      when(
        () => repository.searchWallpapers(const WallpaperQuery(query: 'second')),
      ).thenAnswer((_) => completer2.future);

      final cubit = SearchCubit(repository);

      unawaited(cubit.search('first'));
      unawaited(cubit.search('second'));

      const wallpaper2 = Wallpaper(
        id: '2',
        url: '',
        shortUrl: '',
        views: 0,
        favorites: 0,
        source: '',
        purity: 'sfw',
        category: 'general',
        dimensionX: 0,
        dimensionY: 0,
        resolution: '',
        ratio: '',
        fileSize: 0,
        fileType: '',
        createdAt: '',
        colors: [],
        path: 'second-path',
        thumbs: Thumbs.empty,
        tags: [],
        uploader: Uploader.empty,
      );

      const list1 = WallpaperList(data: [], meta: Meta.empty);
      const list2 = WallpaperList(data: [wallpaper2], meta: Meta.empty);

      completer2.complete(list2);
      await pumpEventQueue();

      completer1.complete(list1);
      await pumpEventQueue();

      expect(cubit.state.wallpaperList, list2);
      expect(cubit.state.wallQuery.query, 'second');
    });

    blocTest<SearchCubit, SearchState>(
      'with hasApiKey == false, togglePurity(2) forces purity[2] to false',
      build: () {
        when(() => repository.hasApiKey).thenReturn(false);
        return SearchCubit(repository);
      },
      act: (cubit) => cubit.togglePurity(2, query: 'test'),
      verify: (_) {
        final captured = verify(
          () => repository.searchWallpapers(captureAny()),
        ).captured.first as WallpaperQuery;
        expect(captured.purity[2], isFalse);
      },
    );

    test('fromJson with legacy loading status (status: 1) does not set loading', () {
      final cubit = SearchCubit(repository);
      final restored = cubit.fromJson({
        'status': 1,
        'wallpaperList': WallpaperList.empty.toJson(),
        'wallQuery': const WallpaperQuery().toJson(),
      });

      expect(restored.status, isNot(SearchStatus.loading));
      expect(restored.status, SearchStatus.initial);
    });
  });
}
