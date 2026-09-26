import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/models/models.dart';
import 'package:haven/data/repository/wallpaper_actions_repository.dart';
import 'package:haven/data/repository/wallpaper_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockHttpClient extends Mock implements http.Client {}

class MockWallpaperStorage extends Mock implements WallpaperStorage {}

class FakeBaseRequest extends Fake implements http.BaseRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBaseRequest());
  });

  group('WallpaperActionsRepository', () {
    late http.Client httpClient;
    late WallpaperStorage storage;
    late WallpaperActionsRepository repository;
    late Directory tempDir;

    setUp(() {
      httpClient = MockHttpClient();
      storage = MockWallpaperStorage();
      tempDir = Directory.systemTemp.createTempSync('wallpaper_actions_test_');

      when(() => storage.isSupported).thenReturn(true);
      when(() => storage.ensureWritePermission()).thenAnswer((_) async {});
      when(() => storage.getWallpaperDirectory()).thenAnswer((_) async => tempDir);

      repository = WallpaperActionsRepository(
        httpClient: httpClient,
        storage: storage,
      );
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('download writes file with body bytes and yields DownloadCompleted', () async {
      final bytes = [10, 20, 30, 40];
      final response = http.StreamedResponse(
        Stream.value(bytes),
        200,
        contentLength: bytes.length,
      );
      when(() => httpClient.send(any())).thenAnswer((_) async => response);

      const url = 'https://w.wallhaven.cc/full/ab/wallhaven-abc.jpg';
      final updates = await repository.download(url).toList();

      final target = File(p.join(tempDir.path, 'wallhaven-abc.jpg'));
      expect(target.existsSync(), isTrue);
      expect(target.readAsBytesSync(), bytes);

      expect(updates.last, isA<DownloadCompleted>());
      final completed = updates.last as DownloadCompleted;
      expect(completed.alreadyExisted, isFalse);
      expect(completed.path, target.path);
    });

    test('existing file yields alreadyExisted: true without http call', () async {
      final target = File(p.join(tempDir.path, 'wallhaven-abc.jpg'))..createSync();
      const url = 'https://w.wallhaven.cc/full/ab/wallhaven-abc.jpg';

      final updates = await repository.download(url).toList();

      verifyNever(() => httpClient.send(any()));
      expect(updates.length, 1);
      expect(updates.first, isA<DownloadCompleted>());
      final completed = updates.first as DownloadCompleted;
      expect(completed.alreadyExisted, isTrue);
      expect(completed.path, target.path);
    });

    test('cancelling subscription after first chunk leaves no .part file', () async {
      final controller = StreamController<List<int>>();
      final response = http.StreamedResponse(
        controller.stream,
        200,
        contentLength: 100,
      );
      when(() => httpClient.send(any())).thenAnswer((_) async => response);

      const url = 'https://w.wallhaven.cc/full/ab/wallhaven-abc.jpg';
      final partFile = File(p.join(tempDir.path, 'wallhaven-abc.jpg.part'));

      final completer = Completer<void>();
      late StreamSubscription<DownloadUpdate> subscription;
      subscription = repository.download(url).listen((update) async {
        if (update is DownloadReceiving) {
          await subscription.cancel();
          completer.complete();
        }
      });

      controller.add([1, 2, 3]);
      await completer.future;
      await controller.close();

      // Give file cleanup a microtask cycle
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(partFile.existsSync(), isFalse);
    });
  });
}
