import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/app_router.dart';
import 'package:haven/core/utils/app_theme.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:haven/features/settings/cubit/settings_cubit.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:haven/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';

class MockWallhavenRepository extends Mock implements WallhavenRepository {}

class MockWallpaperStorage extends Mock implements WallpaperStorage {}

class MockWallpaperActionsRepository extends Mock
    implements WallpaperActionsRepository {}

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockSavedWallpapersCubit extends MockCubit<SavedWallpapersState>
    implements SavedWallpapersCubit {}

void main() {
  group('AppRouter', () {
    late WallhavenRepository wallhavenRepository;
    late WallpaperStorage wallpaperStorage;
    late WallpaperActionsRepository wallpaperActionsRepository;
    late SearchCubit searchCubit;
    late SettingsCubit settingsCubit;
    late SavedWallpapersCubit savedWallpapersCubit;

    const wallpaper = Wallpaper(
      id: 'x',
      url: 'https://example.com/w/x',
      shortUrl: 'https://whvn.cc/x',
      views: 100,
      favorites: 50,
      source: '',
      purity: 'sfw',
      category: 'general',
      dimensionX: 1920,
      dimensionY: 1080,
      resolution: '1920x1080',
      ratio: '1.77',
      fileSize: 1024,
      fileType: 'image/jpeg',
      createdAt: '2023-01-01',
      colors: [],
      path: 'https://example.com/x.jpg',
      thumbs: Thumbs.empty,
      tags: [
        Tag(
          id: 1,
          name: 'anime',
          alias: 'anime',
          categoryId: 1,
          category: 'Anime',
          purity: 'sfw',
          createdAt: '2023-01-01',
        ),
      ],
      uploader: Uploader(
        username: 'artist',
        group: 'User',
        avatar: Avatar.empty,
      ),
    );

    setUp(() {
      wallhavenRepository = MockWallhavenRepository();
      wallpaperStorage = MockWallpaperStorage();
      wallpaperActionsRepository = MockWallpaperActionsRepository();
      searchCubit = MockSearchCubit();
      settingsCubit = MockSettingsCubit();
      savedWallpapersCubit = MockSavedWallpapersCubit();

      when(() => searchCubit.state).thenReturn(const SearchState());
      when(() => settingsCubit.state).thenReturn(const SettingsState());
      when(() => savedWallpapersCubit.state).thenReturn(const SavedWallpapersInitial());

      when(() => searchCubit.search(any())).thenAnswer((_) async {});
      when(
        () => searchCubit.fetchWallpaper(wallQuery: any(named: 'wallQuery')),
      ).thenAnswer((_) async {});
      when(() => wallhavenRepository.hasApiKey).thenReturn(false);
      when(() => wallhavenRepository.getWallpaper('x')).thenAnswer((_) async => wallpaper);
    });

    testWidgets(
        'navigating to wallpaper route, tapping tag searches and routes home',
        (tester) async {
      final router = createRouter();

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: wallhavenRepository),
            RepositoryProvider.value(value: wallpaperStorage),
            RepositoryProvider.value(value: wallpaperActionsRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: searchCubit),
              BlocProvider.value(value: settingsCubit),
              BlocProvider.value(value: savedWallpapersCubit),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              theme: AppTheme.themeData,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      );

      router.go(AppRoutes.wallpaper('x'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('#anime'), findsOneWidget);

      await tester.tap(find.text('#anime'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      verify(() => searchCubit.search('anime')).called(1);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.home,
      );
    });
  });
}
