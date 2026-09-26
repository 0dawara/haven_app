import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWallpaperStorage extends Mock implements WallpaperStorage {}

void main() {
  group('SavedWallpapersCubit', () {
    late WallpaperStorage storage;

    setUp(() {
      storage = MockWallpaperStorage();
    });

    test('initial state is SavedWallpapersInitial', () {
      final cubit = SavedWallpapersCubit(storage);
      expect(cubit.state, const SavedWallpapersInitial());
    });

    test('emission from changes() triggers a re-list of wallpapers', () async {
      final changesController = StreamController<void>.broadcast();
      final initialFiles = [File('path/one.jpg')];
      final updatedFiles = [File('path/one.jpg'), File('path/two.png')];

      var listCallCount = 0;
      when(() => storage.listWallpapers()).thenAnswer((_) async {
        listCallCount++;
        return listCallCount == 1 ? initialFiles : updatedFiles;
      });
      when(() => storage.changes()).thenAnswer((_) => changesController.stream);

      final cubit = SavedWallpapersCubit(storage);

      await cubit.fetchWallpapers();
      expect(cubit.state, SavedWallpapersSuccess(initialFiles));
      expect(listCallCount, 1);

      // Trigger change event
      changesController.add(null);
      await pumpEventQueue();

      expect(cubit.state, SavedWallpapersSuccess(updatedFiles));
      expect(listCallCount, 2);

      await cubit.close();
      await changesController.close();
    });
  });
}
