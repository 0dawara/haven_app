import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:haven/data/data.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

part 'search_state.dart';

class SearchCubit extends HydratedCubit<SearchState> {
  SearchCubit(this._wallhavenRepository) : super(const SearchState());

  final WallhavenRepository _wallhavenRepository;
  static final _logger = Logger('SearchCubit');
  int _requestId = 0;

  Future<void> fetchWallpaper({WallpaperQuery? wallQuery}) async {
    var query = wallQuery ?? state.wallQuery;
    if (!_wallhavenRepository.hasApiKey &&
        query.purity.length == 3 &&
        query.purity[2]) {
      query = query.copyWith(
        purity: [query.purity[0], query.purity[1], false],
      );
    }

    final requestId = ++_requestId;
    emit(state.copyWith(status: SearchStatus.loading, wallQuery: query));

    try {
      final wallpaperList = await _wallhavenRepository.searchWallpapers(query);
      if (requestId != _requestId || isClosed) return;
      emit(
        state.copyWith(
          status: SearchStatus.success,
          wallpaperList: wallpaperList,
          wallQuery: query,
        ),
      );
    } catch (e, s) {
      if (requestId != _requestId || isClosed) return;
      _logger.severe('Failed to fetch wallpapers', e, s);
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<void> search(String query) =>
      fetchWallpaper(wallQuery: state.wallQuery.copyWith(query: query, page: 1));

  Future<void> setSorting(WallpaperSorting sorting, {required String query}) =>
      fetchWallpaper(
        wallQuery: state.wallQuery.copyWith(
          sorting: sorting,
          query: query,
          page: 1,
        ),
      );

  Future<void> toggleCategory(int index, {required String query}) {
    final categories = List<bool>.from(state.wallQuery.category);
    categories[index] = !categories[index];
    return fetchWallpaper(
      wallQuery: state.wallQuery.copyWith(
        category: categories,
        query: query,
        page: 1,
      ),
    );
  }

  Future<void> togglePurity(int index, {required String query}) {
    final purity = List<bool>.from(state.wallQuery.purity);
    purity[index] = !purity[index];
    return fetchWallpaper(
      wallQuery: state.wallQuery.copyWith(
        purity: purity,
        query: query,
        page: 1,
      ),
    );
  }

  Future<void> goToPage(int page) =>
      fetchWallpaper(wallQuery: state.wallQuery.copyWith(page: page));

  Future<void> refresh({required String query}) =>
      fetchWallpaper(wallQuery: state.wallQuery.copyWith(query: query));

  @override
  SearchState fromJson(Map<String, dynamic> json) => SearchState.fromJson(json);

  @override
  Map<String, dynamic> toJson(SearchState state) => state.toJson();
}
