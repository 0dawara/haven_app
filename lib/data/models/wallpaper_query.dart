import 'package:equatable/equatable.dart';

enum WallpaperSorting {
  latest,
  relevance,
  random,
  views,
  favorites,
  toplist,
  hot,
}

enum WallpaperOrder { asc, desc }

enum WallpaperTopRange {
  day,
  threeDays,
  week,
  month,
  threeMonths,
  sixMonths,
  year;

  String get value {
    switch (this) {
      case day:
        return '1d';
      case threeDays:
        return '3d';
      case week:
        return '1w';
      case month:
        return '1M';
      case threeMonths:
        return '3M';
      case sixMonths:
        return '6M';
      case year:
        return '1y';
    }
  }
}

class WallpaperQuery extends Equatable {
  const WallpaperQuery({
    this.query,
    this.category = const [true, true, false],
    this.purity = const [true, false, null],
    this.sorting = WallpaperSorting.toplist,
    this.order = WallpaperOrder.desc,
    this.topRange = WallpaperTopRange.month,
    this.page,
    this.apikey,
  });

  factory WallpaperQuery.fromJson(Map<String, dynamic> json) => WallpaperQuery(
    query: json['q'] as String?,
    category: List<bool>.from(
      (json['categories'] as String).split('').map((e) => e == '1'),
    ),
    purity: List<bool?>.from(
      (json['purity'] as String).split('').map((e) => e == '1'),
    ),
    sorting: WallpaperSorting.values.firstWhere(
      (e) => e.name == json['sorting'],
    ),
    order: WallpaperOrder.values.firstWhere((e) => e.name == json['order']),
    topRange: WallpaperTopRange.values.firstWhere(
      (e) => e.value == json['topRange'],
    ),
    page: json['page'] as int?,
    apikey: json['apikey'] as String?,
  );

  final String? query;
  final List<bool>? category;
  final List<bool?>? purity;
  final WallpaperSorting? sorting;
  final WallpaperOrder? order;
  final WallpaperTopRange? topRange;
  final int? page;
  final String? apikey;

  WallpaperQuery copyWith({
    String? query,
    List<bool>? category,
    List<bool?>? purity,
    WallpaperSorting? sorting,
    WallpaperOrder? order,
    WallpaperTopRange? topRange,
    int? page,
    String? apikey,
  }) => WallpaperQuery(
    query: query ?? this.query,
    category: category ?? this.category,
    purity: purity ?? this.purity,
    sorting: sorting ?? this.sorting,
    order: order ?? this.order,
    topRange: topRange ?? this.topRange,
    page: page ?? this.page,
    apikey: apikey ?? this.apikey,
  );

  Map<String, dynamic> toJson() => {
    if (query != null && query!.isNotEmpty) 'q': query,
    if (category != null && category!.length == 3)
      'categories': category!.map((e) => e ? '1' : '0').join(),
    if (purity != null && purity!.length == 3)
      'purity': purity!.map((e) => e != null && e ? '1' : '0').join(),
    if (sorting != null) 'sorting': sorting!.name,
    if (order != null) 'order': order!.name,
    if (topRange != null && sorting == WallpaperSorting.toplist)
      'topRange': topRange!.value,
    if (page != null) 'page': page.toString(),
    if (apikey != null && apikey!.isNotEmpty) 'apikey': apikey,
  };

  @override
  List<Object?> get props => [
    query,
    category,
    purity,
    sorting,
    order,
    topRange,
    page,
    apikey,
  ];
}
