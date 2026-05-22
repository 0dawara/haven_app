import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven_app/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:haven_app/features/saved_wallpapers/view/downloaded_wallpaper_page.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return BlocBuilder<SavedWallpapersCubit, SavedWallpapersState>(
      builder: (context, state) {
        final wallpapers = state is SavedWallpapersSuccess ? state.wallpapers : <FileSystemEntity>[];
        
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
                if (wallpapers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      wallpapers.length > 1
                          ? '${wallpapers.length} wallpapers that you saved'
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
                        itemCount: wallpapers.length,
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
                                            wallpapers[index].path,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Image.file(
                                File(wallpapers[index].path),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      state is SavedWallpapersLoading 
                        ? "Loading wallpapers..."
                        : "Can't find any saved wallpaper",
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
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
