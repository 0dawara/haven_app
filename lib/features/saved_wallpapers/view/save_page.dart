import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:haven_app/features/saved_wallpapers/view/downloaded_wallpaper_page.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  Future<List<FileSystemEntity>> getImages() async {
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

    if (dir.existsSync()) {
      return dir.listSync();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return FutureBuilder<List<FileSystemEntity>>(
      future: getImages(),
      builder: (context, snapshot) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 64),
                  child: Text(
                    'Saved',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
                if (snapshot.hasData && snapshot.data!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      snapshot.data!.length > 1
                          ? '${snapshot.data!.length} wallpapers that you saved'
                          : 'A wallpaper you saved',
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DownloadedWallpaperPage(
                                          file: File(
                                            snapshot.data![index].path,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Image.file(
                                File(snapshot.data![index].path),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaSize.width > 1200
                              ? 5
                              : mediaSize.width > 800
                              ? 4
                              : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: mediaSize.height / 3,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      "Can't find any saved wallpaper",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
