import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:haven_app/core/core.dart';
import 'package:haven_app/data/data.dart';

class InfoDialog extends StatelessWidget {
  InfoDialog({required this.wallpaper, super.key});

  final Wallpaper wallpaper;

  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  String mathFunc(Match match) => '${match[1]},';

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future<void> copyColor({
    required BuildContext context,
    required String color,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    return Clipboard.setData(ClipboardData(text: color)).whenComplete(() {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text('Color $color copied to clipboard')),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Info'),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: <TextSpan>[
            const TextSpan(
              text: 'id: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.id),
            const TextSpan(
              text: '\nuploader: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.uploader.username,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(
                  Uri.parse(
                    'https://wallhaven.cc/user/${wallpaper.uploader.username}',
                  ),
                ),
            ),
            const TextSpan(
              text: '\ncategory: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.category),
            const TextSpan(
              text: '\nresolution: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.resolution),
            const TextSpan(
              text: '\ntype: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.fileType),
            const TextSpan(
              text: '\nsize: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: formatBytes(wallpaper.fileSize, 2)),
            const TextSpan(
              text: '\nviews: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.views.toString().replaceAllMapped(reg, mathFunc),
            ),
            const TextSpan(
              text: '\nfavorites: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.favorites.toString().replaceAllMapped(
                reg,
                mathFunc,
              ),
            ),
            const TextSpan(
              text: '\nlink: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: wallpaper.shortUrl,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(Uri.parse(wallpaper.shortUrl)),
            ),
            const TextSpan(
              text: '\ndate added: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: wallpaper.createdAt),
            const TextSpan(
              text: '\ncolors: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final color in wallpaper.colors) ...[
              TextSpan(text: color == wallpaper.colors.first ? '[ ' : ''),
              TextSpan(
                text: '■',
                style: TextStyle(color: HexColor.fromHex(color)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async =>
                      copyColor(context: context, color: color),
              ),
              TextSpan(
                text: color == wallpaper.colors.last ? ' $color' : ' $color, ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async =>
                      copyColor(context: context, color: color),
              ),
              TextSpan(text: color == wallpaper.colors.last ? ' ]' : ''),
            ],
            const TextSpan(
              text: '\ntags: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final tag in wallpaper.tags) ...[
              TextSpan(text: tag == wallpaper.tags.first ? '[ ' : ''),
              TextSpan(
                text: tag.name,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(
                    Uri.parse('https://wallhaven.cc/tag/${tag.id}'),
                  ),
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
