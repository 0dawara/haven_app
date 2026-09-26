import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/core/widgets/api_error_view.dart';
import 'package:haven/core/widgets/home_wallpaper_list.dart';
import 'package:haven/data/models/wallpaper_query.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:mocktail/mocktail.dart';
import '../../helpers/helpers.dart';

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(const WallpaperQuery());
  });

  group('ApiErrorView', () {
    testWidgets('renders title, message, and calls onRetry when tapped',
        (tester) async {
      var retryCount = 0;
      await tester.pumpApp(
        Scaffold(
          body: ApiErrorView(
            onRetry: () => retryCount++,
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
      await tester.pumpApp(
        const Scaffold(
          body: ApiErrorView(),
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

      await tester.pumpApp(
        BlocProvider<SearchCubit>.value(
          value: mockSearchCubit,
          child: Scaffold(
            body: HomeWallpaperList(
              onRefresh: () async {},
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
