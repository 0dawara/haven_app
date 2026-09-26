import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haven/app_router.dart';
import 'package:haven/core/core.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/wallpaper_actions/view/save_dialog.dart';
import 'package:haven/features/wallpaper_actions/view/share_dialog.dart';
import 'package:haven/features/wallpaper_details/cubit/details_cubit.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:haven/l10n/l10n.dart';

class WallpaperDetailsPage extends StatefulWidget {
  const WallpaperDetailsPage({required this.id, this.url, super.key});

  final String id;
  final String? url;

  @override
  State<WallpaperDetailsPage> createState() => _WallpaperDetailsPageState();
}

class _WallpaperDetailsPageState extends State<WallpaperDetailsPage> {
  BoxFit _fit = BoxFit.cover;
  bool _showUI = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        final imageUrl = widget.url ?? state.wallpaper?.path;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: _DetailsImage(
                  url: imageUrl,
                  fit: _fit,
                  onTap: () => setState(() => _showUI = !_showUI),
                ),
              ),
              AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !_showUI,
                  child: Stack(
                    children: [
                      _TopControls(
                        fit: _fit,
                        onBack: () => context.pop(),
                        onToggleFit: () => setState(
                          () => _fit = _fit == BoxFit.cover
                              ? BoxFit.contain
                              : BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _InfoPanel(
                          wallpaper: state.wallpaper,
                          status: state.status,
                          imageUrl: imageUrl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailsImage extends StatelessWidget {
  const _DetailsImage({
    required this.url,
    required this.fit,
    required this.onTap,
  });

  final String? url;
  final BoxFit fit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 5,
      minScale: 1,
      child: GestureDetector(
        onTap: onTap,
        child: url != null && url!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url!,
                filterQuality: FilterQuality.high,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
                height: double.infinity,
                width: double.infinity,
                fit: fit,
              )
            : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({
    required this.fit,
    required this.onBack,
    required this.onToggleFit,
  });

  final BoxFit fit;
  final VoidCallback onBack;
  final VoidCallback onToggleFit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 48,
          left: 16,
          child: IconButton(
            tooltip: context.l10n.tooltipBack,
            icon: const Icon(CupertinoIcons.back),
            color: Colors.white,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black45),
            ),
            onPressed: onBack,
          ),
        ),
        Positioned(
          top: 48,
          right: 16,
          child: IconButton(
            tooltip: context.l10n.tooltipToggleFit,
            icon: Icon(
              fit == BoxFit.cover
                  ? Icons.aspect_ratio_outlined
                  : Icons.image_aspect_ratio_outlined,
            ),
            color: Colors.white,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black45),
            ),
            onPressed: onToggleFit,
          ),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.wallpaper,
    required this.status,
    required this.imageUrl,
  });

  final Wallpaper? wallpaper;
  final DetailsStatus status;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: switch (status) {
            DetailsStatus.loading => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            DetailsStatus.failure => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.detailsLoadFailed,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.read<DetailsCubit>().fetch(),
                        child: Text(context.l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),
            DetailsStatus.success => wallpaper == null
                ? const SizedBox.shrink()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      _UploaderRow(wallpaper: wallpaper!),
                      const SizedBox(height: 24),
                      _TagList(tags: wallpaper!.tags),
                      const SizedBox(height: 32),
                      _ActionButtons(
                        wallpaper: wallpaper!,
                        imageUrl: imageUrl ?? wallpaper!.path,
                      ),
                    ],
                  ),
          },
        ),
      ),
    );
  }
}

class _UploaderRow extends StatelessWidget {
  const _UploaderRow({required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white10,
          backgroundImage: wallpaper.uploader.avatar.px128.isNotEmpty
              ? NetworkImage(wallpaper.uploader.avatar.px128)
              : null,
          child: wallpaper.uploader.avatar.px128.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wallpaper.uploader.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.detailsUploader,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
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
                    wallpaper.resolution,
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
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
                    formatBytes(wallpaper.fileSize, decimals: 1),
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
    );
  }
}

class _TagList extends StatelessWidget {
  const _TagList({required this.tags});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return GestureDetector(
            onTap: () {
              context.read<SearchCubit>().search(tag.name);
              context.go(AppRoutes.home);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                '#${tag.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.wallpaper,
    required this.imageUrl,
  });

  final Wallpaper wallpaper;
  final String imageUrl;

  Future<void> _share(BuildContext context, bool asFile) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = context.read<WallpaperActionsRepository>();
    final shareFailedText = context.l10n.shareFailed;
    try {
      await repo.share(url: imageUrl, asFile: asFile);
    } on Exception {
      messenger.showSnackBar(
        SnackBar(content: Text(shareFailedText)),
      );
    } finally {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => SaveDialog(url: imageUrl),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.l10n.detailsSaveWallpaper,
              style: const TextStyle(
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
                onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      InfoDialog(wallpaper: wallpaper),
                ),
                icon: const Icon(
                  CupertinoIcons.info,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  context.l10n.actionInfo,
                  style: const TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  builder: (ctx) => ShareDialog(
                    onPressedFile: () => _share(ctx, true),
                    onPressedLink: () => _share(ctx, false),
                  ),
                ),
                icon: const Icon(
                  CupertinoIcons.share,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  context.l10n.actionShare,
                  style: const TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
