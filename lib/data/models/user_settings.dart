import 'package:equatable/equatable.dart';

class UserSettings extends Equatable {
  const UserSettings({
    required this.thumbSize,
    required this.perPage,
    required this.purity,
    required this.categories,
    required this.resolutions,
    required this.aspectRatios,
    required this.toplistRange,
    required this.tagBlacklist,
    required this.userBlacklist,
    required this.aiArtFilter,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
    thumbSize: json['thumb_size'] == null ? '' : json['thumb_size'] as String,
    perPage: json['per_page'] == null ? '' : json['per_page'] as String,
    purity: json['purity'] == null
        ? []
        : (json['purity'] as List<dynamic>).map((e) => e as String).toList(),
    categories: json['categories'] == null
        ? []
        : (json['categories'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    resolutions: json['resolutions'] == null
        ? []
        : (json['resolutions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    aspectRatios: json['aspect_ratios'] == null
        ? []
        : (json['aspect_ratios'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    toplistRange: json['toplist_range'] == null
        ? ''
        : json['toplist_range'] as String,
    tagBlacklist: json['tag_blacklist'] == null
        ? []
        : (json['tag_blacklist'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    userBlacklist: json['user_blacklist'] == null
        ? []
        : (json['user_blacklist'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    aiArtFilter: json['ai_art_filter'] == null
        ? 0
        : json['ai_art_filter'] as int,
  );

  final String thumbSize;
  final String perPage;
  final List<String> purity;
  final List<String> categories;
  final List<String> resolutions;
  final List<String> aspectRatios;
  final String toplistRange;
  final List<String> tagBlacklist;
  final List<String> userBlacklist;
  final int aiArtFilter;

  static const empty = UserSettings(
    thumbSize: '',
    perPage: '',
    purity: [],
    categories: [],
    resolutions: [],
    aspectRatios: [],
    toplistRange: '',
    tagBlacklist: [],
    userBlacklist: [],
    aiArtFilter: 0,
  );

  Map<String, dynamic> toJson() => {
    'thumb_size': thumbSize,
    'per_page': perPage,
    'purity': purity,
    'categories': categories,
    'resolutions': resolutions,
    'aspect_ratios': aspectRatios,
    'toplist_range': toplistRange,
    'tag_blacklist': tagBlacklist,
    'user_blacklist': userBlacklist,
    'ai_art_filter': aiArtFilter,
  };

  @override
  List<Object?> get props => [
    thumbSize,
    perPage,
    purity,
    categories,
    resolutions,
    aspectRatios,
    toplistRange,
    tagBlacklist,
    userBlacklist,
    aiArtFilter,
  ];

  @override
  String toString() =>
      'UserSettings(thumbSize: $thumbSize, perPage: $perPage, purity: $purity, categories: $categories, resolutions: $resolutions, aspectRatios: $aspectRatios, toplistRange: $toplistRange, tagBlacklist: $tagBlacklist, userBlacklist: $userBlacklist, aiArtFilter: $aiArtFilter)';
}
