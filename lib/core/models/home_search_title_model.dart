import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HomeSearchTitleVariant {
  toplist(Icons.diamond_outlined, Colors.purple, 'Best of the month'),
  latest(Icons.schedule_outlined, Colors.green, 'Latest'),
  hot(Icons.local_fire_department_outlined, Colors.red, 'Hot'),
  random(Icons.shuffle_outlined, Colors.orange, 'Random'),
  search(Icons.search, Colors.grey, '');

  const HomeSearchTitleVariant(this.icon, this.color, this.defaultTitle);

  final IconData icon;
  final Color color;
  final String defaultTitle;
}

class HomeSearchTitleModel extends Equatable {
  const HomeSearchTitleModel({
    required this.variant,
    required this.searchTitle,
  });

  factory HomeSearchTitleModel.fromJson(Map<String, dynamic> json) {
    final searchTitle =
        json['searchTitle'] as String? ??
        HomeSearchTitleVariant.toplist.defaultTitle;
    final variantName = json['variant'] as String?;
    final variant =
        HomeSearchTitleVariant.values.firstWhereOrNull(
          (variant) => variant.name == variantName,
        ) ??
        HomeSearchTitleVariant.values.firstWhereOrNull(
          (variant) => variant.defaultTitle == searchTitle,
        ) ??
        HomeSearchTitleVariant.search;

    return HomeSearchTitleModel(variant: variant, searchTitle: searchTitle);
  }

  const HomeSearchTitleModel.toplist()
    : variant = HomeSearchTitleVariant.toplist,
      searchTitle = 'Best of the month';

  const HomeSearchTitleModel.latest()
    : variant = HomeSearchTitleVariant.latest,
      searchTitle = 'Latest';

  const HomeSearchTitleModel.hot()
    : variant = HomeSearchTitleVariant.hot,
      searchTitle = 'Hot';

  const HomeSearchTitleModel.random()
    : variant = HomeSearchTitleVariant.random,
      searchTitle = 'Random';

  const HomeSearchTitleModel.search(String query)
    : variant = HomeSearchTitleVariant.search,
      searchTitle = query;

  final HomeSearchTitleVariant variant;
  final String searchTitle;

  IconData get icon => variant.icon;

  Color get iconColor => variant.color;

  Map<String, dynamic> toJson() => {
    'variant': variant.name,
    'searchTitle': searchTitle,
  };

  @override
  List<Object?> get props => [variant, searchTitle];

  @override
  String toString() {
    return 'HomeSearchTitleModel(variant: ${variant.name}, searchTitle: $searchTitle)';
  }
}
