import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:haven_app/data/models/models.dart';

/// Exception thrown when wallpaperSearch fails.
class WallpaperSearchRequestFailure implements Exception {
  const WallpaperSearchRequestFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperSearchRequestFailure(message: $message)';
}

/// Exception thrown when the provided wallpaper is not found.
class WallpaperNotFoundFailure implements Exception {
  const WallpaperNotFoundFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperNotFoundFailure(message: $message)';
}

/// Exception thrown when the provided wallpaper id info is not found.
class WallpaperIdInfoNotFoundFailure implements Exception {
  const WallpaperIdInfoNotFoundFailure(this.message);

  final String message;

  @override
  String toString() => 'WallpaperIdInfoNotFoundFailure(message: $message)';
}

/// Exception thrown when the provided wallhaven apikey is not valid.
class WallhavenApikeyNotValidFailure implements Exception {
  const WallhavenApikeyNotValidFailure(this.message);

  final String message;

  @override
  String toString() => 'WallhavenApikeyNotValidFailure(message: $message)';
}

/// {@template wallhaven_api_client}
/// Dart API Client which wraps the [wallhaven](https://wallhaven.cc/).
/// {@endtemplate}
class WallhavenApiClient {
  /// {@macro open_meteo_api_client}
  WallhavenApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'wallhaven.cc';

  final http.Client _httpClient;

  /// Finds a [Wallpaper]. (Default: `/search?sorting=toplist`)
  Future<WallpaperList> wallpaperSearch({WallpaperQuery? wallQuery}) async {
    final queryParameters = wallQuery == null
        ? {'sorting': 'toplist'}
        : wallQuery.toJson();

    final request = Uri.https(_baseUrl, '/api/v1/search', queryParameters);

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallpaperSearchRequestFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperListJson = jsonDecode(response.body) as Map<String, dynamic>;

    if (!wallpaperListJson.containsKey('data')) {
      throw const WallpaperNotFoundFailure(
        'Wallpaper not found. Please check your query.',
      );
    }

    return WallpaperList.fromJson(wallpaperListJson);
  }

  /// Get [Wallpaper] info by id.
  Future<WallpaperInfo> wallpaperInfo({
    required String id,
    String? apikey,
  }) async {
    final request = Uri.https(
      _baseUrl,
      '/api/v1/w/$id',
      apikey != null ? {'apikey': apikey} : null,
    );

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallpaperIdInfoNotFoundFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final wallpaperInfoJson = jsonDecode(response.body) as Map<String, dynamic>;

    return WallpaperInfo.fromJson(wallpaperInfoJson);
  }

  /// Get [UserSettings] validation by apikey.
  Future<UserSettings> apikeyValidation({required String apikey}) async {
    final request = Uri.https(_baseUrl, '/api/v1/settings', {'apikey': apikey});

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallhavenApikeyNotValidFailure(
        'Request failed with status: ${response.statusCode}',
      );
    }

    final userSettingsJson = jsonDecode(response.body) as Map<String, dynamic>;

    return UserSettings.fromJson(userSettingsJson);
  }
}
