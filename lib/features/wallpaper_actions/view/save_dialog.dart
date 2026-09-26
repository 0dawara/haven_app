import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/wallpaper_actions/cubit/download_cubit.dart';
import 'package:haven/l10n/l10n.dart';

class SaveDialog extends StatelessWidget {
  const SaveDialog({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) =>
          DownloadCubit(c.read<WallpaperActionsRepository>())..start(url),
      child: const _SaveDialogContent(),
    );
  }
}

class _SaveDialogContent extends StatelessWidget {
  const _SaveDialogContent();

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(context.l10n.saveTitle),
      content: BlocBuilder<DownloadCubit, DownloadState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              switch (state) {
                DownloadPreparing() => Column(
                    children: [
                      const CupertinoActivityIndicator(),
                      const SizedBox(height: 10),
                      Text(context.l10n.downloadPreparing),
                    ],
                  ),
                DownloadInProgress(:final fraction) => Column(
                    children: [
                      LinearProgressIndicator(value: fraction),
                      const SizedBox(height: 10),
                      Text(
                        fraction != null
                            ? context.l10n.downloadProgress(
                                (fraction * 100).toInt(),
                              )
                            : context.l10n.downloadIndeterminate,
                      ),
                    ],
                  ),
                DownloadSuccess(:final alreadyExisted) => Text(
                    alreadyExisted
                        ? context.l10n.downloadAlreadyExists
                        : context.l10n.downloadSuccess,
                  ),
                DownloadFailure(:final reason) => Text(
                    switch (reason) {
                      DownloadFailureReason.permissionDenied =>
                        context.l10n.downloadPermissionDenied,
                      DownloadFailureReason.unsupportedPlatform =>
                        context.l10n.downloadUnsupported,
                      DownloadFailureReason.network =>
                        context.l10n.downloadFailed,
                    },
                  ),
              },
            ],
          );
        },
      ),
    );
  }
}
