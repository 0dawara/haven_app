import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:haven_app/data/repository/wallpaper_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ActionsCubit {
  ActionsCubit({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static final _logger = Logger('ActionsCubit');

  Stream<String> downloadImageStream({required String url}) {
    if (Platform.isIOS) {
      return Stream.error('Please use the Share button!');
    } else if (!Platform.isAndroid &&
        !Platform.isMacOS &&
        !Platform.isWindows &&
        !Platform.isLinux) {
      return Stream.error('Operating system not supported!');
    }

    try {
      late final StreamController<String> controller;

      controller = StreamController<String>(
        onListen: () async {
          try {
            controller.add('Getting pictures folder...');

            if (Platform.isAndroid) {
              await verifyPermission();
            }

            final dir = await WallpaperStorage.getWallpaperDirectory();

            if (!dir.existsSync()) {
              controller.add('Creating wallhaven folder...');
              dir.createSync(recursive: true);
            }

            final file = File(
              '${dir.path}${url.substring(url.lastIndexOf('/') + 1)}',
            );
            controller.add('Downloading image...');

            if (file.existsSync()) {
              controller.add('Image already downloaded!');
              await controller.close();
              return;
            }

            final response = await _httpClient.get(Uri.parse(url));
            if (response.statusCode != 200) {
              throw Exception(
                'Failed to download image: ${response.statusCode}',
              );
            }
            final fileBodyBytes = response.bodyBytes;
            file.writeAsBytesSync(fileBodyBytes);

            controller.add('Image downloaded at Pictures/wallhaven/');
            await controller.close();
          } catch (e, s) {
            _logger.severe('Failed to download image from $url', e, s);
            controller.addError('Error on download image!');
            await controller.close();
          }
        },
      );

      return controller.stream;
    } catch (e, s) {
      _logger.severe('Failed to create download stream for $url', e, s);
      return Stream.error('Error on download image!');
    }
  }

  Future<void> verifyPermission() async {
    final deviceInfo = DeviceInfoPlugin();

    switch (Platform.operatingSystem) {
      case 'android':
        final androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt < 33) {
          await Permission.storage.request();
        } else {
          await Permission.photos.request();
        }
    }
  }

  Future<void> shareWallpaper({
    required String url,
    required bool isFile,
  }) async {
    try {
      late final ShareParams shareParams;

      if (isFile && !Platform.isLinux) {
        final dir = await getTemporaryDirectory();

        final file = File(
          '${dir.path}/${url.substring(url.lastIndexOf('/') + 1)}',
        );
        final response = await _httpClient.get(Uri.parse(url));
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to download image for sharing: ${response.statusCode}',
          );
        }
        final fileBodyBytes = response.bodyBytes;
        file.writeAsBytesSync(fileBodyBytes);

        shareParams = ShareParams(files: [XFile(file.path)]);
      } else {
        if (Platform.isAndroid || Platform.isIOS) {
          shareParams = ShareParams(uri: Uri.parse(url));
        } else {
          shareParams = ShareParams(text: url);
        }
      }

      await SharePlus.instance.share(shareParams);
    } on Exception catch (e, s) {
      _logger.severe('Failed to share wallpaper: $url', e, s);
    }
  }
}
