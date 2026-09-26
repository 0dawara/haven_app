import 'package:collection/collection.dart';
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
    this.query = '',
    this.category = const [true, true, false],
    this.purity = const [true, false, false],
    this.sorting = WallpaperSorting.toplist,
    this.order = WallpaperOrder.desc,
    this.topRange = WallpaperTopRange.month,
    this.page = 1,
  });

  factory WallpaperQuery.fromJson(Map<String, dynamic> json) => WallpaperQuery(
    query: switch (json['q'] ?? json['query']) {
      final String q => q,
      _ => '',
    },
    category: _parseBits(json['categories'], const [true, true, false]),
    purity: _parseBits(json['purity'], const [true, false, false]),
    sorting:
        WallpaperSorting.values.asNameMap()[json['sorting']] ??
        WallpaperSorting.toplist,
    order:
        WallpaperOrder.values.asNameMap()[json['order']] ?? WallpaperOrder.desc,
    topRange:
        WallpaperTopRange.values.firstWhereOrNull(
          (e) => e.value == json['topRange'],
        ) ??
        WallpaperTopRange.month,
    page: switch (json['page']) {
      final int p => p,
      final String s => int.tryParse(s) ?? 1,
      _ => 1,
    },
  );

  static List<bool> _parseBits(dynamic value, List<bool> fallback) {
    if (value is String &&
        value.length == 3 &&
        value.split('').every((c) => c == '0' || c == '1')) {
      return value.split('').map((c) => c == '1').toList();
    }
    return fallback;
  }

  final String query;
  final List<bool> category;
  final List<bool> purity;
  final WallpaperSorting sorting;
  final WallpaperOrder order;
  final WallpaperTopRange topRange;
  final int page;

  WallpaperQuery copyWith({
    String? query,
    List<bool>? category,
    List<bool>? purity,
    WallpaperSorting? sorting,
    WallpaperOrder? order,
    WallpaperTopRange? topRange,
    int? page,
  }) => WallpaperQuery(
    query: query ?? this.query,
    category: category ?? this.category,
    purity: purity ?? this.purity,
    sorting: sorting ?? this.sorting,
    order: order ?? this.order,
    topRange: topRange ?? this.topRange,
    page: page ?? this.page,
  );

  Map<String, String> toQueryParameters() => {
    if (query.isNotEmpty) 'q': query,
    'categories': category.map((e) => e ? '1' : '0').join(),
    'purity': purity.map((e) => e ? '1' : '0').join(),
    'sorting': sorting.name,
    'order': order.name,
    if (sorting == WallpaperSorting.toplist) 'topRange': topRange.value,
    'page': '$page',
  };

  Map<String, dynamic> toJson() => {
    'q': query,
    'categories': category.map((e) => e ? '1' : '0').join(),
    'purity': purity.map((e) => e ? '1' : '0').join(),
    'sorting': sorting.name,
    'order': order.name,
    'topRange': topRange.value,
    'page': page,
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
  ];
}
