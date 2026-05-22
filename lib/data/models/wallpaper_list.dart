import 'package:equatable/equatable.dart';
import 'package:haven_app/data/models/models.dart';

class WallpaperList extends Equatable {
  const WallpaperList({required this.data, required this.meta});

  factory WallpaperList.fromJson(Map<String, dynamic> json) => WallpaperList(
    data: json['data'] == null
        ? []
        : (json['data'] as List<dynamic>)
              .map((dynamic e) => Wallpaper.fromJson(e as Map<String, dynamic>))
              .toList(),
    meta: json['meta'] == null
        ? Meta.empty
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );

  final List<Wallpaper> data;
  final Meta meta;

  static const empty = WallpaperList(data: [], meta: Meta.empty);

  Map<String, dynamic> toJson() => {
    'data': data.map((Wallpaper e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };

  @override
  List<Object?> get props => [data, meta];

  @override
  String toString() => 'WallpaperList(data: $data, meta: $meta)';
}
