import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/core/models/home_search_title_model.dart';
import 'package:haven/core/widgets/api_error_view.dart';
import 'package:haven/core/widgets/home_colors_tone_list.dart';
import 'package:haven/core/widgets/home_wallpaper_list.dart';
import 'package:haven/data/models/wallpaper_query.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:haven/features/wallpaper_search/view/wallpaper_list_page.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const WallpaperQuery());
  });

  group('ApiErrorView', () {
    testWidgets('renders title, message, and calls onRetry when tapped',
        (tester) async {
      var retryCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiErrorView(
              onRetry: () => retryCount++,
            ),
          ),
        ),
      );

      expect(find.text('Wallhaven is having a moment'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      expect(retryCount, 1);
    });

    testWidgets('does not render Try again button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ApiErrorView(),
          ),
        ),
      );

      expect(find.text('Wallhaven is having a moment'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    });
  });

  group('HomeWallpaperList', () {
    testWidgets('renders ApiErrorView on failure and retries on tap',
        (tester) async {
      final mockSearchCubit = MockSearchCubit();
      whenListen(
        mockSearchCubit,
        const Stream<SearchState>.empty(),
        initialState: const SearchState(status: SearchStatus.failure),
      );
      when(
        () => mockSearchCubit.fetchWallpaper(
          wallQuery: any(named: 'wallQuery'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        BlocProvider<SearchCubit>.value(
          value: mockSearchCubit,
          child: MaterialApp(
            home: Scaffold(
              body: HomeWallpaperList(
                onRefresh: () async {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Wallhaven is having a moment'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      verify(
        () => mockSearchCubit.fetchWallpaper(
          wallQuery: any(named: 'wallQuery'),
        ),
      ).called(1);
    });
  });

  group('HomeColorsToneList', () {
    testWidgets('renders SizedBox.shrink on failure without error message',
        (tester) async {
      final mockSearchCubit = MockSearchCubit();
      whenListen(
        mockSearchCubit,
        const Stream<SearchState>.empty(),
        initialState: const SearchState(status: SearchStatus.failure),
      );

      await tester.pumpWidget(
        BlocProvider<SearchCubit>.value(
          value: mockSearchCubit,
          child: const MaterialApp(
            home: Scaffold(
              body: HomeColorsToneList(),
            ),
          ),
        ),
      );

      expect(find.text('Failed to load colors'), findsNothing);
      expect(find.text('The color tone'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });

  group('WallpaperListPage', () {
    testWidgets('renders ApiErrorView on failure and retries on tap',
        (tester) async {
      final mockSearchCubit = MockSearchCubit();
      whenListen(
        mockSearchCubit,
        const Stream<SearchState>.empty(),
        initialState: const SearchState(status: SearchStatus.failure),
      );
      when(() => mockSearchCubit.state).thenReturn(
        const SearchState(status: SearchStatus.failure),
      );
      when(
        () => mockSearchCubit.fetchWallpaper(
          wallQuery: any(named: 'wallQuery'),
        ),
      ).thenAnswer((_) async {});

      late BuildContext outerContext;
      await tester.pumpWidget(
        BlocProvider<SearchCubit>.value(
          value: mockSearchCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                outerContext = context;
                return Scaffold(
                  body: WallpaperListPage(
                    titleModel: const HomeSearchTitleModel.toplist(),
                    ctx: outerContext,
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Wallhaven is having a moment'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      verify(
        () => mockSearchCubit.fetchWallpaper(
          wallQuery: any(named: 'wallQuery'),
        ),
      ).called(1);
    });
  });
}
