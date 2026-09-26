import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xdg_directories/xdg_directories.dart';

class DownloadPermissionDeniedException implements Exception {}

class DownloadUnsupportedPlatformException implements Exception {}

class WallpaperStorage {
  bool get isSupported =>
      Platform.isAndroid ||
      Platform.isWindows ||
      Platform.isMacOS ||
      Platform.isLinux;

  Future<Directory> getWallpaperDirectory() async {
    if (!isSupported) {
      throw UnsupportedError(
        'Platform ${Platform.operatingSystem} is not supported',
      );
    }

    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Pictures/wallhaven');
    }
    if (Platform.isWindows) {
      final dynamic rawPath = await PathProviderWindows().getPath(
        '{33E28130-4E1E-4676-835A-98395C3BC3BB}',
      );
      final picturesPath = rawPath as String?;
      if (picturesPath == null || picturesPath.isEmpty) {
        throw UnsupportedError('Could not resolve Windows Pictures directory');
      }
      return Directory(p.join(picturesPath, 'wallhaven'));
    }
    if (Platform.isMacOS) {
      final docDir = await getApplicationDocumentsDirectory();
      return Directory(
        p.joinAll([
          ...p.split(docDir.path).take(3),
          'Pictures',
          'wallhaven',
        ]),
      );
    }
    if (Platform.isLinux) {
      final picturesDir =
          getUserDirectory('PICTURES') ??
          Directory(p.join(Platform.environment['HOME'] ?? '', 'Pictures'));
      return Directory(p.join(picturesDir.path, 'wallhaven'));
    }

    throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported',
    );
  }

  Future<void> ensureWritePermission() async {
    if (!Platform.isAndroid) return;
    final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdkInt <= 28) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw DownloadPermissionDeniedException();
      }
    } else if (sdkInt <= 32) {
      await Permission.storage.request();
    } else {
      await Permission.photos.request();
    }
  }

  Future<List<File>> listWallpapers() async {
    if (!isSupported) return [];
    final dir = await getWallpaperDirectory();
    if (!await dir.exists()) return [];

    final files = <File>[];
    await for (final entity in dir.list()) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (ext == '.jpg' || ext == '.jpeg' || ext == '.png') {
          files.add(entity);
        }
      }
    }
    files.sort((a, b) => p.basename(a.path).compareTo(p.basename(b.path)));
    return files;
  }

  Stream<void> changes() async* {
    if (!isSupported || !FileSystemEntity.isWatchSupported) return;
    final dir = await getWallpaperDirectory();
    await dir.create(recursive: true);
    yield* dir.watch().map((_) {});
  }
}
