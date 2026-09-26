import 'dart:async';
import 'dart:convert';

import 'package:haven/data/api/logging_client.dart';
import 'package:haven/data/models/models.dart';
import 'package:http/http.dart' as http;

/// Base exception for Wallhaven API operations.
sealed class WallhavenException implements Exception {
  const WallhavenException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType(message: $message)';
}

final class WallhavenRequestFailure extends WallhavenException {
  const WallhavenRequestFailure(this.statusCode)
      : super('Request failed with status: $statusCode');
  final int statusCode;
}

final class WallhavenRateLimitFailure extends WallhavenException {
  const WallhavenRateLimitFailure() : super('Rate limit exceeded');
}

final class WallhavenNotFoundFailure extends WallhavenException {
  const WallhavenNotFoundFailure(super.message);
}

final class WallhavenInvalidApiKeyFailure extends WallhavenException {
  const WallhavenInvalidApiKeyFailure() : super('API key is not valid');
}

/// {@template wallhaven_api_client}
/// Dart API Client which wraps the [wallhaven](https://wallhaven.cc/).
/// {@endtemplate}
class WallhavenApiClient {
  /// {@macro wallhaven_api_client}
  WallhavenApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? LoggingClient(http.Client());

  static const _baseUrl = 'wallhaven.cc';
  static const requestTimeout = Duration(seconds: 20);

  final http.Client _httpClient;

  Future<http.Response> _get(Uri uri, String? apiKey) {
    return _httpClient
        .get(
          uri,
          headers: {
            if (apiKey != null && apiKey.isNotEmpty) 'X-API-Key': apiKey,
          },
        )
        .timeout(requestTimeout);
  }

  /// Finds a [WallpaperList].
  Future<WallpaperList> searchWallpapers(
    WallpaperQuery query, {
    String? apiKey,
  }) async {
    final uri = Uri.https(
      _baseUrl,
      '/api/v1/search',
      query.toQueryParameters(),
    );
    final response = await _get(uri, apiKey);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (!json.containsKey('data')) {
        throw const WallhavenNotFoundFailure(
          'Wallpaper not found. Please check your query.',
        );
      }
      return WallpaperList.fromJson(json);
    }

    if (response.statusCode == 429) {
      throw const WallhavenRateLimitFailure();
    }

    throw WallhavenRequestFailure(response.statusCode);
  }

  /// Get [Wallpaper] by id.
  Future<Wallpaper> getWallpaper(String id, {String? apiKey}) async {
    final uri = Uri.https(_baseUrl, '/api/v1/w/$id');
    final response = await _get(uri, apiKey);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Wallpaper.fromJson(json['data'] as Map<String, dynamic>);
    }

    if (response.statusCode == 404) {
      throw const WallhavenNotFoundFailure('Wallpaper not found.');
    }

    if (response.statusCode == 429) {
      throw const WallhavenRateLimitFailure();
    }

    throw WallhavenRequestFailure(response.statusCode);
  }

  /// Get [UserSettings] validation by apikey.
  Future<UserSettings> getUserSettings({required String apiKey}) async {
    final uri = Uri.https(_baseUrl, '/api/v1/settings');
    final response = await _get(uri, apiKey);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserSettings.fromJson(json['data'] as Map<String, dynamic>);
    }

    if (response.statusCode == 401 || response.statusCode == 404) {
      throw const WallhavenInvalidApiKeyFailure();
    }

    if (response.statusCode == 429) {
      throw const WallhavenRateLimitFailure();
    }

    throw WallhavenRequestFailure(response.statusCode);
  }
}
