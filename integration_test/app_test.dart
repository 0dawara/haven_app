import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/haven_app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app loads wallpapers, opens details, and renders save button',
      (tester) async {
    final tempDir = Directory.systemTemp.createTempSync('haven_integration_');
    addTearDown(() {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(tempDir.path),
    );

    await tester.pumpWidget(
      HavenApp(wallhavenRepository: WallhavenRepository()),
    );
    await tester.pump();

    var imageLoaded = false;
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.byType(CachedNetworkImage).evaluate().isNotEmpty) {
        imageLoaded = true;
        break;
      }
    }
    expect(imageLoaded, isTrue, reason: 'Failed to load wallpaper images in 30s');

    await tester.tap(find.byType(CachedNetworkImage).first);
    await tester.pump();

    var saveButtonFound = false;
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text('Save Wallpaper').evaluate().isNotEmpty) {
        saveButtonFound = true;
        break;
      }
    }
    expect(saveButtonFound, isTrue, reason: 'Save Wallpaper button not found in 30s');
  });
}
