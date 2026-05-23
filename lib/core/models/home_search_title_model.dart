import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/core/utils/color_extension.dart';
import 'package:haven_app/core/utils/icondata_extension.dart';

class HomeSearchTitleModel extends Equatable {
  const HomeSearchTitleModel({
    required this.icon,
    required this.iconColor,
    required this.searchTitle,
  });

  factory HomeSearchTitleModel.fromJson(Map<String, dynamic> json) {
    return HomeSearchTitleModel(
      icon: IconSerialization.fromJson(json['icon'] as Map<String, dynamic>),
      iconColor: HexColor.fromHex(json['iconColor'] as String),
      searchTitle: json['searchTitle'] as String,
    );
  }

  const HomeSearchTitleModel.toplist()
    : icon = Icons.diamond_outlined,
      iconColor = Colors.purple,
      searchTitle = 'Best of the month';

  const HomeSearchTitleModel.latest()
    : icon = Icons.schedule_outlined,
      iconColor = Colors.green,
      searchTitle = 'Latest';

  const HomeSearchTitleModel.hot()
    : icon = Icons.local_fire_department_outlined,
      iconColor = Colors.red,
      searchTitle = 'Hot';

  const HomeSearchTitleModel.random()
    : icon = Icons.shuffle_outlined,
      iconColor = Colors.orange,
      searchTitle = 'Random';

  const HomeSearchTitleModel.search(String query)
    : icon = Icons.search,
      iconColor = Colors.grey,
      searchTitle = query;

  final IconData icon;
  final Color iconColor;
  final String searchTitle;

  Map<String, dynamic> toJson() => {
    'icon': icon.toJson(),
    'iconColor': iconColor.toHex(),
    'searchTitle': searchTitle,
  };

  @override
  List<Object?> get props => [icon, iconColor, searchTitle];

  @override
  String toString() {
    return 'HomeSearchTitleModel(icon: $icon, iconColor: $iconColor, searchTitle: $searchTitle)';
  }
}
