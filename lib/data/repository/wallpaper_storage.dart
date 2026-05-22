import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WallpaperStorage {
  static Future<Directory> getWallpaperDirectory() async {
    late Directory dir;
    switch (Platform.operatingSystem) {
      case 'android':
        dir = Directory('storage/emulated/0/Pictures/wallhaven/');
      case 'macos':
        final docDir = await getApplicationDocumentsDirectory();
        final listDirString = docDir.path.split('/');
        dir = Directory('/Users/${listDirString[2]}/Pictures/wallhaven/');
      case 'windows':
        final docDir = await getApplicationDocumentsDirectory();
        final listDirString = docDir.path.split(r'\');
        dir = Directory('C:/Users/${listDirString[2]}/Pictures/wallhaven/');
      case 'linux':
        final docDir = await getApplicationDocumentsDirectory();
        dir = Directory(
          docDir.path.replaceRange(
            docDir.path.lastIndexOf('/'),
            null,
            '/Pictures/wallhaven/',
          ),
        );
      default:
        dir = Directory('');
    }
    return dir;
  }
}
