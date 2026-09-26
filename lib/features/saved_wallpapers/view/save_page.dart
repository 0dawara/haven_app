import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haven/app_router.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_state.dart';
import 'package:haven/l10n/l10n.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedWallpapersCubit, SavedWallpapersState>(
      builder: (context, state) {
        final wallpapers = state is SavedWallpapersSuccess
            ? state.wallpapers
            : <File>[];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 64),
                  child: Text(
                    context.l10n.savedTitle,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (wallpapers.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      context.l10n.savedCount(wallpapers.length),
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
                              onTap: () => context.push(
                                AppRoutes.savedFile(wallpapers[index].path),
                              ),
                              child: Image.file(
                                wallpapers[index],
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                                cacheWidth: (240 *
                                        MediaQuery.devicePixelRatioOf(context))
                                    .round(),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      state is SavedWallpapersLoading
                          ? context.l10n.savedLoading
                          : context.l10n.savedEmpty,
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
