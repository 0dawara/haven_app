part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.wallpaperList = WallpaperList.empty,
    this.colorsData = const {},
    this.wallQuery = const WallpaperQuery(),
    this.homeSearchTitleModel = const HomeSearchTitleModel.toplist(),
  });

  factory SearchState.fromJson(Map<String, dynamic> json) => SearchState(
    status: SearchStatus.values[json['status'] as int? ?? 0],
    wallpaperList: json['wallpaperList'] == null
        ? WallpaperList.empty
        : WallpaperList.fromJson(json['wallpaperList'] as Map<String, dynamic>),
    colorsData: json['colorsData'] == null
        ? {}
        : Map<String, int>.from(json['colorsData'] as Map<String, dynamic>),
    wallQuery: json['wallQuery'] == null
        ? const WallpaperQuery()
        : WallpaperQuery.fromJson(json['wallQuery'] as Map<String, dynamic>),
    homeSearchTitleModel: json['homeSearchTitleModel'] == null
        ? const HomeSearchTitleModel.toplist()
        : HomeSearchTitleModel.fromJson(
            json['homeSearchTitleModel'] as Map<String, dynamic>,
          ),
  );

  final SearchStatus status;
  final WallpaperList wallpaperList;
  final Map<String, int> colorsData;
  final WallpaperQuery wallQuery;
  final HomeSearchTitleModel homeSearchTitleModel;

  SearchState copyWith({
    SearchStatus? status,
    WallpaperList? wallpaperList,
    Map<String, int>? colorsData,
    WallpaperQuery? wallQuery,
    HomeSearchTitleModel? homeSearchTitleModel,
  }) {
    return SearchState(
      status: status ?? this.status,
      wallpaperList: wallpaperList ?? this.wallpaperList,
      colorsData: colorsData ?? this.colorsData,
      wallQuery: wallQuery ?? this.wallQuery,
      homeSearchTitleModel: homeSearchTitleModel ?? this.homeSearchTitleModel,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.index,
    'wallpaperList': wallpaperList.toJson(),
    'colorsData': colorsData,
    'wallQuery': wallQuery.toJson(),
    'homeSearchTitleModel': homeSearchTitleModel.toJson(),
  };

  @override
  List<Object?> get props => [
    status,
    wallpaperList,
    colorsData,
    wallQuery,
    homeSearchTitleModel,
  ];
}
