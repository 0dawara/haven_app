part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.wallpaperList = WallpaperList.empty,
    this.wallQuery = const WallpaperQuery(),
  });

  factory SearchState.fromJson(Map<String, dynamic> json) {
    final list = json['wallpaperList'] == null
        ? WallpaperList.empty
        : WallpaperList.fromJson(json['wallpaperList'] as Map<String, dynamic>);
    return SearchState(
      status:
          list.data.isNotEmpty ? SearchStatus.success : SearchStatus.initial,
      wallpaperList: list,
      wallQuery: json['wallQuery'] == null
          ? const WallpaperQuery()
          : WallpaperQuery.fromJson(json['wallQuery'] as Map<String, dynamic>),
    );
  }

  final SearchStatus status;
  final WallpaperList wallpaperList;
  final WallpaperQuery wallQuery;

  SearchState copyWith({
    SearchStatus? status,
    WallpaperList? wallpaperList,
    WallpaperQuery? wallQuery,
  }) {
    return SearchState(
      status: status ?? this.status,
      wallpaperList: wallpaperList ?? this.wallpaperList,
      wallQuery: wallQuery ?? this.wallQuery,
    );
  }

  Map<String, dynamic> toJson() => {
    'wallpaperList': wallpaperList.toJson(),
    'wallQuery': wallQuery.toJson(),
  };

  @override
  List<Object?> get props => [
    status,
    wallpaperList,
    wallQuery,
  ];
}
