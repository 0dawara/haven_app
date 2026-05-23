import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:haven_app/data/repository/wallpaper_storage.dart';
import 'package:haven_app/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:logging/logging.dart';

class SavedWallpapersCubit extends Cubit<SavedWallpapersState> {
  SavedWallpapersCubit() : super(SavedWallpapersInitial());

  StreamSubscription<FileSystemEvent>? _subscription;
  static final _logger = Logger('SavedWallpapersCubit');

  Future<void> fetchWallpapers() async {
    try {
      final dir = await WallpaperStorage.getWallpaperDirectory();
      if (dir.existsSync()) {
        final wallpapers = dir.listSync();
        emit(SavedWallpapersSuccess(wallpapers));
        _initWatcher(dir);
      } else {
        emit(const SavedWallpapersSuccess([]));
        _initParentWatcher(dir);
      }
    } catch (e, s) {
      _logger.severe('Failed to fetch saved wallpapers', e, s);
      emit(SavedWallpapersFailure(e.toString()));
    }
  }

  void _initWatcher(Directory dir) {
    _subscription?.cancel();
    _subscription = dir.watch().listen((event) {
      _updateWallpapers(dir);
    });
  }

  void _initParentWatcher(Directory dir) {
    _subscription?.cancel();
    final parent = dir.parent;
    if (parent.existsSync()) {
      _subscription = parent.watch().listen((event) {
        if (dir.existsSync()) {
          fetchWallpapers();
        }
      });
    }
  }

  void _updateWallpapers(Directory dir) {
    if (dir.existsSync()) {
      final wallpapers = dir.listSync();
      emit(SavedWallpapersSuccess(wallpapers));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
