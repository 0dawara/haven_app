import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haven/data/data.dart';
import 'package:logging/logging.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this._repository, {required this.id})
      : super(const DetailsState());

  final WallhavenRepository _repository;
  final String id;
  static final _logger = Logger('DetailsCubit');

  Future<void> fetch() async {
    emit(state.copyWith(status: DetailsStatus.loading));
    try {
      final wallpaper = await _repository.getWallpaper(id);
      emit(state.copyWith(status: DetailsStatus.success, wallpaper: wallpaper));
    } catch (e, s) {
      _logger.severe('Failed to get wallpaper info for id: $id', e, s);
      emit(state.copyWith(status: DetailsStatus.failure));
    }
  }
}
