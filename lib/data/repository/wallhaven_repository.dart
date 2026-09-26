import 'dart:async';

import 'package:haven/data/api/wallhaven_api_client.dart';
import 'package:haven/data/models/models.dart';

class WallhavenRepository {
  WallhavenRepository({WallhavenApiClient? wallhavenApiClient})
    : _wallhavenApiClient = wallhavenApiClient ?? WallhavenApiClient();

  final WallhavenApiClient _wallhavenApiClient;
  String? _apiKey;

  bool get hasApiKey => _apiKey?.isNotEmpty ?? false;

  void updateApiKey(String? apiKey) {
    _apiKey = apiKey;
  }

  Future<WallpaperList> searchWallpapers(WallpaperQuery query) async {
    return _wallhavenApiClient.searchWallpapers(query, apiKey: _apiKey);
  }

  Future<Wallpaper> getWallpaper(String id) async {
    return _wallhavenApiClient.getWallpaper(id, apiKey: _apiKey);
  }

  Future<UserSettings> validateApiKey(String apiKey) async {
    return _wallhavenApiClient.getUserSettings(apiKey: apiKey);
  }
}
