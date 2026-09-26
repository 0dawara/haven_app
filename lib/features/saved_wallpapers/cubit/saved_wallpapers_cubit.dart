import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:haven/data/repository/wallpaper_storage.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:logging/logging.dart';

class SavedWallpapersCubit extends Cubit<SavedWallpapersState> {
  SavedWallpapersCubit(this._storage) : super(const SavedWallpapersInitial());

  final WallpaperStorage _storage;
  StreamSubscription<void>? _subscription;
  static final _logger = Logger('SavedWallpapersCubit');

  Future<void> fetchWallpapers() async {
    try {
      emit(SavedWallpapersSuccess(await _storage.listWallpapers()));
      _subscription ??= _storage.changes().listen(
            (_) => _reload(),
            onError: (Object error, StackTrace stackTrace) {
              _logger.severe('Saved wallpapers watcher error', error, stackTrace);
            },
          );
    } catch (e, s) {
      _logger.severe('Failed to fetch saved wallpapers', e, s);
      emit(SavedWallpapersFailure(e.toString()));
    }
  }

  Future<void> _reload() async {
    try {
      emit(SavedWallpapersSuccess(await _storage.listWallpapers()));
    } catch (e, s) {
      _logger.severe('Failed to reload saved wallpapers', e, s);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
