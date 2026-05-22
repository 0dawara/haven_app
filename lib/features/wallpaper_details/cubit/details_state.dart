part of 'details_cubit.dart';

class DetailsState extends Equatable {
  const DetailsState({this.wallpaperInfo});

  factory DetailsState.fromJson(Map<String, dynamic> json) => DetailsState(
    wallpaperInfo: json['wallpaperInfo'] == null
        ? null
        : WallpaperInfo.fromJson(json['wallpaperInfo'] as Map<String, dynamic>),
  );

  final WallpaperInfo? wallpaperInfo;

  DetailsState copyWith({WallpaperInfo? wallpaperInfo}) {
    return DetailsState(wallpaperInfo: wallpaperInfo ?? this.wallpaperInfo);
  }

  Map<String, dynamic> toJson() => {'wallpaperInfo': wallpaperInfo?.toJson()};

  @override
  List<Object?> get props => [wallpaperInfo];
}
