import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:haven_app/core/core.dart';
import 'package:haven_app/data/data.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'search_state.dart';

class SearchCubit extends HydratedCubit<SearchState> {
  SearchCubit(this._wallhavenRepository) : super(const SearchState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> fetchWallpaper({WallpaperQuery? wallQuery}) async {
    if (state.status != SearchStatus.loading) {
      emit(state.copyWith(status: SearchStatus.loading));

      try {
        final wallpaperList = await _wallhavenRepository.getWallpaper(
          wallQuery: wallQuery,
        );

        emit(
          state.copyWith(
            status: SearchStatus.success,
            wallpaperList: wallpaperList,
            colorsData: getColorsData(wallpaperList.data),
            wallQuery: wallQuery,
          ),
        );
      } catch (e) {
        log('e = $e', name: 'SearchCubit');
        emit(state.copyWith(status: SearchStatus.failure));
      }
    }
  }

  Future<void> fetchMoreWallpapers() async {
    if (state.status == SearchStatus.loading ||
        state.isLoadingMore ||
        state.wallpaperList.meta.currentPage >=
            state.wallpaperList.meta.lastPage) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.wallpaperList.meta.currentPage + 1;
      final wallQuery = state.wallQuery.copyWith(page: nextPage);

      final wallpaperList = await _wallhavenRepository.getWallpaper(
        wallQuery: wallQuery,
      );

      final newWallpaperList = WallpaperList(
        data: state.wallpaperList.data + wallpaperList.data,
        meta: wallpaperList.meta,
      );

      emit(
        state.copyWith(
          isLoadingMore: false,
          wallpaperList: newWallpaperList,
          colorsData: getColorsData(newWallpaperList.data),
        ),
      );
    } catch (e) {
      log('e = $e', name: 'SearchCubit');
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Map<String, int> getColorsData(List<Wallpaper> data) {
    final colorsMap = <String, int>{};

    for (final wallpaper in data) {
      for (final color in wallpaper.colors) {
        colorsMap[color] = (colorsMap[color] ?? 0) + 1;
      }
    }

    return colorsMap;
  }

  void updateStatus(SearchStatus status) =>
      emit(state.copyWith(status: status));

  void updateWallpaperQuery(WallpaperQuery wallQuery) =>
      emit(state.copyWith(wallQuery: wallQuery));

  void updateHomeSearchTitleModel(HomeSearchTitleModel titleModel) =>
      emit(state.copyWith(homeSearchTitleModel: titleModel));

  @override
  SearchState fromJson(Map<String, dynamic> json) => SearchState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SearchState state) => state.toJson();
}
