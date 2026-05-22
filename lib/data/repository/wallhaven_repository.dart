import 'dart:async';

import 'package:haven_app/data/api/wallhaven_api_client.dart';
import 'package:haven_app/data/models/models.dart';

class WallhavenRepository {
  WallhavenRepository({WallhavenApiClient? wallhavenApiClient})
    : _wallhavenApiClient = wallhavenApiClient ?? WallhavenApiClient();

  final WallhavenApiClient _wallhavenApiClient;

  Future<WallpaperList> getWallpaper({WallpaperQuery? wallQuery}) async {
    final wallpaperList = await _wallhavenApiClient.wallpaperSearch(
      wallQuery: wallQuery,
    );
    return wallpaperList;
  }

  Future<WallpaperInfo> getWallpaperInfo({
    required String id,
    String? apikey,
  }) async {
    final wallpaper = await _wallhavenApiClient.wallpaperInfo(
      id: id,
      apikey: apikey,
    );
    return wallpaper;
  }

  Future<UserSettings> apikeyValidation({required String apikey}) async {
    final userSettings = await _wallhavenApiClient.apikeyValidation(
      apikey: apikey,
    );
    return userSettings;
  }
}
