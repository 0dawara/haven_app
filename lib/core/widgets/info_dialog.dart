import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haven/core/core.dart';
import 'package:haven/data/data.dart';
import 'package:haven/l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoDialog extends StatefulWidget {
  const InfoDialog({required this.wallpaper, super.key});

  final Wallpaper wallpaper;

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  final List<TapGestureRecognizer> _recognizers = [];
  late final TapGestureRecognizer _uploaderRecognizer;
  late final TapGestureRecognizer _linkRecognizer;
  late final Map<String, TapGestureRecognizer> _colorBlockRecognizers;
  late final Map<String, TapGestureRecognizer> _colorTextRecognizers;
  late final Map<int, TapGestureRecognizer> _tagRecognizers;

  TapGestureRecognizer _createRecognizer(VoidCallback onTap) {
    final recognizer = TapGestureRecognizer()..onTap = onTap;
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  void initState() {
    super.initState();
    _uploaderRecognizer = _createRecognizer(() {
      unawaited(
        launchUrl(
          Uri.parse(
            'https://wallhaven.cc/user/${widget.wallpaper.uploader.username}',
          ),
        ),
      );
    });

    _linkRecognizer = _createRecognizer(() {
      unawaited(launchUrl(Uri.parse(widget.wallpaper.shortUrl)));
    });

    _colorBlockRecognizers = {
      for (final color in widget.wallpaper.colors)
        color: _createRecognizer(() {
          unawaited(copyColor(context: context, color: color));
        }),
    };

    _colorTextRecognizers = {
      for (final color in widget.wallpaper.colors)
        color: _createRecognizer(() {
          unawaited(copyColor(context: context, color: color));
        }),
    };

    _tagRecognizers = {
      for (final tag in widget.wallpaper.tags)
        tag.id: _createRecognizer(() {
          unawaited(
            launchUrl(Uri.parse('https://wallhaven.cc/tag/${tag.id}')),
          );
        }),
    };
  }

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  Future<void> copyColor({
    required BuildContext context,
    required String color,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.l10n.colorCopied(color);

    return Clipboard.setData(ClipboardData(text: color)).whenComplete(() {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );
    final wallpaper = widget.wallpaper;

    return CupertinoAlertDialog(
      title: Text(context.l10n.actionInfo),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: '${context.l10n.infoId}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.id),
            TextSpan(
              text: '\n${context.l10n.infoUploader}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.uploader.username,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: _uploaderRecognizer,
            ),
            TextSpan(
              text: '\n${context.l10n.infoCategory}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.category),
            TextSpan(
              text: '\n${context.l10n.infoResolution}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.resolution),
            TextSpan(
              text: '\n${context.l10n.infoType}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.fileType),
            TextSpan(
              text: '\n${context.l10n.infoSize}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: formatBytes(wallpaper.fileSize, decimals: 2)),
            TextSpan(
              text: '\n${context.l10n.infoViews}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: numberFormat.format(wallpaper.views)),
            TextSpan(
              text: '\n${context.l10n.infoFavorites}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: numberFormat.format(wallpaper.favorites)),
            TextSpan(
              text: '\n${context.l10n.infoLink}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.shortUrl,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
              recognizer: _linkRecognizer,
            ),
            TextSpan(
              text: '\n${context.l10n.infoDateAdded}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.createdAt),
            TextSpan(
              text: '\n${context.l10n.infoColors}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final color in wallpaper.colors) ...[
              TextSpan(text: color == wallpaper.colors.first ? '[ ' : ''),
              TextSpan(
                text: '■',
                style: TextStyle(color: HexColor.fromHex(color)),
                recognizer: _colorBlockRecognizers[color],
              ),
              TextSpan(
                text: color == wallpaper.colors.last ? ' $color' : ' $color, ',
                recognizer: _colorTextRecognizers[color],
              ),
              TextSpan(text: color == wallpaper.colors.last ? ' ]' : ''),
            ],
            TextSpan(
              text: '\n${context.l10n.infoTags}: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final tag in wallpaper.tags) ...[
              TextSpan(text: tag == wallpaper.tags.first ? '[ ' : ''),
              TextSpan(
                text: tag.name,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: _tagRecognizers[tag.id],
              ),
              TextSpan(text: tag == wallpaper.tags.last ? '' : ', '),
              TextSpan(text: tag == wallpaper.tags.last ? ' ]' : ''),
            ],
          ],
        ),
      ),
    );
  }
}
