part of 'details_cubit.dart';

enum DetailsStatus { loading, success, failure }

class DetailsState extends Equatable {
  const DetailsState({
    this.status = DetailsStatus.loading,
    this.wallpaper,
  });

  final DetailsStatus status;
  final Wallpaper? wallpaper;

  DetailsState copyWith({
    DetailsStatus? status,
    Wallpaper? wallpaper,
  }) {
    return DetailsState(
      status: status ?? this.status,
      wallpaper: wallpaper ?? this.wallpaper,
    );
  }

  @override
  List<Object?> get props => [status, wallpaper];
}
