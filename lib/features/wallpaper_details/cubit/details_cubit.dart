import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:haven_app/data/data.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'details_state.dart';

class DetailsCubit extends HydratedCubit<DetailsState> {
  DetailsCubit(this._wallhavenRepository) : super(const DetailsState());

  final WallhavenRepository _wallhavenRepository;

  Future<void> getWallpaperInfo({required String id, String? apikey}) async {
    try {
      final wallpaper = await _wallhavenRepository.getWallpaperInfo(
        id: id,
        apikey: apikey,
      );
      emit(state.copyWith(wallpaperInfo: wallpaper));
    } on Exception catch (e) {
      log('e = $e', name: 'DetailsCubit');
    }
  }

  @override
  DetailsState fromJson(Map<String, dynamic> json) =>
      DetailsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(DetailsState state) => state.toJson();
}
