import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/core/core.dart';
import 'package:haven_app/features/settings/cubit/settings_cubit.dart';
import 'package:haven_app/features/wallpaper_actions/cubit/actions_cubit.dart';
import 'package:haven_app/features/wallpaper_details/cubit/details_cubit.dart';

class WallpaperDetailsPage extends StatefulWidget {
  const WallpaperDetailsPage({required this.id, required this.url, super.key});

  final String id;
  final String url;

  @override
  State<WallpaperDetailsPage> createState() => _WallpaperDetailsPageState();
}

class _WallpaperDetailsPageState extends State<WallpaperDetailsPage> {
  DetailsCubit get detailsCubit => context.read<DetailsCubit>();
  ActionsCubit get actionsCubit => context.read<ActionsCubit>();
  SettingsCubit get settingsCubit => context.read<SettingsCubit>();

  BoxFit fit = BoxFit.cover;
  bool showUI = true;

  @override
  void initState() {
    super.initState();
    detailsCubit.getWallpaperInfo(
      id: widget.id,
      apikey: settingsCubit.state.apikey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Wallpaper Image (Full Screen)
          Positioned.fill(
            child: InteractiveViewer(
              maxScale: 5,
              minScale: 1,
              child: GestureDetector(
                onTap: () => setState(() => showUI = !showUI),
                child: CachedNetworkImage(
                  imageUrl: widget.url,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                  height: double.infinity,
                  width: double.infinity,
                  fit: fit,
                ),
              ),
            ),
          ),

          // 2. UI Elements
          AnimatedOpacity(
            opacity: showUI ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !showUI,
              child: Stack(
                children: [
                  Positioned(
                    top: 48,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.back),
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black45),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 48,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        fit == BoxFit.cover
                            ? Icons.aspect_ratio_outlined
                            : Icons.image_aspect_ratio_outlined,
                      ),
                      color: Colors.white,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black45),
                      ),
                      onPressed: () => setState(
                        () => fit = fit == BoxFit.cover
                            ? BoxFit.contain
                            : BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BlocBuilder<DetailsCubit, DetailsState>(
                      builder: (context, state) {
                        final info = state.wallpaperInfo?.data;
                        if (info == null) return const SizedBox.shrink();

                        return Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(24),
                            children: [
                              const SizedBox(height: 12),
                              // 1. Top Section: Uploader & Specs
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      info.uploader.avatar.px128,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          info.uploader.username,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Uploader',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.6,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.aspect_ratio,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              info.resolution,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.sd_storage,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              convertBytesToReadableSize(
                                                info.fileSize,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // 2. Middle Section: Tags
                              SizedBox(
                                height: 32,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: info.tags.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final tag = info.tags[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.white12),
                                      ),
                                      child: Text(
                                        '#${tag.name}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),

                              // 3. Bottom Section: Actions
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      () => showCupertinoModalPopup<void>(
                                        context: context,
                                        builder:
                                            (BuildContext context) =>
                                                SaveDialog(
                                                  stream:
                                                      actionsCubit
                                                          .downloadImageStream(
                                                            url: widget.url,
                                                          ),
                                                ),
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Save Wallpaper',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          () => showCupertinoModalPopup<void>(
                                            context: context,
                                            builder:
                                                (BuildContext context) =>
                                                    InfoDialog(wallpaper: info),
                                          ),
                                      icon: const Icon(
                                        CupertinoIcons.info,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Info',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white24,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          () => showCupertinoModalPopup<void>(
                                            context: context,
                                            builder: (ctx) {
                                              final navigator = Navigator.of(
                                                ctx,
                                              );
                                              return ShareDialog(
                                                onPressedFile:
                                                    () => actionsCubit
                                                        .shareWallpaper(
                                                          url: widget.url,
                                                          isFile: true,
                                                        )
                                                        .then(
                                                          (val) =>
                                                              navigator.pop(),
                                                        ),
                                                onPressedLink:
                                                    () => actionsCubit
                                                        .shareWallpaper(
                                                          url: widget.url,
                                                          isFile: false,
                                                        )
                                                        .then(
                                                          (val) =>
                                                              navigator.pop(),
                                                        ),
                                              );
                                            },
                                          ),
                                      icon: const Icon(
                                        CupertinoIcons.share,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Share',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white24,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String convertBytesToReadableSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
}
