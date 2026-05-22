import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haven_app/core/widgets/rounded_square_button.dart';
import 'package:share_plus/share_plus.dart';

class DownloadedWallpaperPage extends StatefulWidget {
  const DownloadedWallpaperPage({required this.file, super.key});

  final File file;

  @override
  State<DownloadedWallpaperPage> createState() =>
      _DownloadedWallpaperPageState();
}

class _DownloadedWallpaperPageState extends State<DownloadedWallpaperPage> {
  BoxFit fit = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(
              widget.file,
              filterQuality: FilterQuality.high,
              fit: fit,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(CupertinoIcons.back),
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white24),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 48,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.aspect_ratio_outlined),
              color: Colors.white,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white24),
              ),
              onPressed: () => setState(
                () => fit = fit == BoxFit.cover ? BoxFit.contain : BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedSquareButton(
                  name: 'Share',
                  icon: CupertinoIcons.share,
                  action: () => SharePlus.instance.share(
                    ShareParams(files: [XFile(widget.file.path)]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
