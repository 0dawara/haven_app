import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class SavedWallpapersState extends Equatable {
  const SavedWallpapersState();

  @override
  List<Object?> get props => [];
}

class SavedWallpapersInitial extends SavedWallpapersState {}

class SavedWallpapersLoading extends SavedWallpapersState {}

class SavedWallpapersSuccess extends SavedWallpapersState {
  const SavedWallpapersSuccess(this.wallpapers);

  final List<FileSystemEntity> wallpapers;

  @override
  List<Object?> get props => [wallpapers];
}

class SavedWallpapersFailure extends SavedWallpapersState {
  const SavedWallpapersFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
