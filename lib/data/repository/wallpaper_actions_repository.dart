import 'dart:async';
import 'dart:io';

import 'package:haven/data/api/wallhaven_api_client.dart';
import 'package:haven/data/models/models.dart';
import 'package:haven/data/repository/wallpaper_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WallpaperActionsRepository {
  WallpaperActionsRepository({
    required this.httpClient,
    required this.storage,
  });

  final http.Client httpClient;
  final WallpaperStorage storage;

  Stream<DownloadUpdate> download(String url) async* {
    if (!storage.isSupported) {
      throw DownloadUnsupportedPlatformException();
    }

    await storage.ensureWritePermission();
    final dir = await storage.getWallpaperDirectory();
    await dir.create(recursive: true);

    final filename = p.basename(Uri.parse(url).path);
    final target = File(p.join(dir.path, filename));

    if (await target.exists()) {
      yield DownloadCompleted(path: target.path, alreadyExisted: true);
      return;
    }

    final partFile = File('${target.path}.part');
    IOSink? sink;
    var completed = false;

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await httpClient
          .send(request)
          .timeout(WallhavenApiClient.requestTimeout);

      if (response.statusCode != 200) {
        throw WallhavenRequestFailure(response.statusCode);
      }

      sink = partFile.openWrite();
      var received = 0;
      final total = response.contentLength;

      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        yield DownloadReceiving(received: received, total: total);
      }

      await sink.flush();
      await sink.close();
      sink = null;

      await partFile.rename(target.path);
      completed = true;
      yield DownloadCompleted(path: target.path, alreadyExisted: false);
    } finally {
      if (sink != null) {
        try {
          await sink.close();
        } catch (_) {}
      }
      if (!completed && await partFile.exists()) {
        try {
          await partFile.delete();
        } catch (_) {}
      }
    }
  }

  Future<void> share({required String url, required bool asFile}) async {
    final ShareParams shareParams;

    if (asFile && !Platform.isLinux) {
      final tempDir = await getTemporaryDirectory();
      final file = File(p.join(tempDir.path, p.basename(Uri.parse(url).path)));
      final response = await httpClient
          .get(Uri.parse(url))
          .timeout(WallhavenApiClient.requestTimeout);

      if (response.statusCode != 200) {
        throw WallhavenRequestFailure(response.statusCode);
      }

      await file.writeAsBytes(response.bodyBytes);
      shareParams = ShareParams(files: [XFile(file.path)]);
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        shareParams = ShareParams(uri: Uri.parse(url));
      } else {
        shareParams = ShareParams(text: url);
      }
    }

    await SharePlus.instance.share(shareParams);
  }

  void close() => httpClient.close();
}
