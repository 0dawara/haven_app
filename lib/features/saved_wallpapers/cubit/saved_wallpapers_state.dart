import 'dart:io';
import 'package:equatable/equatable.dart';

sealed class SavedWallpapersState extends Equatable {
  const SavedWallpapersState();

  @override
  List<Object?> get props => [];
}

final class SavedWallpapersInitial extends SavedWallpapersState {
  const SavedWallpapersInitial();
}

final class SavedWallpapersLoading extends SavedWallpapersState {
  const SavedWallpapersLoading();
}

final class SavedWallpapersSuccess extends SavedWallpapersState {
  const SavedWallpapersSuccess(this.wallpapers);

  final List<File> wallpapers;

  @override
  List<Object?> get props => [wallpapers];
}

final class SavedWallpapersFailure extends SavedWallpapersState {
  const SavedWallpapersFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
