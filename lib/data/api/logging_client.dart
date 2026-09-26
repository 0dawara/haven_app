import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// A [http.BaseClient] that logs all requests and responses.
class LoggingClient extends http.BaseClient {
  LoggingClient(this._inner);

  final http.Client _inner;
  final _logger = Logger('HttpClient');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    _logger.info('--> ${request.method} ${request.url}');
    final sanitizedHeaders = request.headers.map((key, value) {
      if (key.toLowerCase() == 'x-api-key') {
        return MapEntry(key, '***');
      }
      return MapEntry(key, value);
    });
    _logger.finer('Headers: $sanitizedHeaders');

    if (request is http.Request && request.body.isNotEmpty) {
      _logger.finer('Body: ${request.body}');
    }

    try {
      final response = await _inner.send(request);
      final duration = DateTime.now().difference(startTime);

      _logger.info(
        '<-- ${response.statusCode} ${request.url} (${duration.inMilliseconds}ms)',
      );
      _logger.finer('Headers: ${response.headers}');

      final contentType =
          response.headers['content-type']?.toLowerCase() ?? '';
      final isTextOrJson =
          contentType.startsWith('application/json') ||
          contentType.startsWith('text/');
      if (!isTextOrJson) {
        return response;
      }

      final bytes = await response.stream.toBytes();
      if (bytes.isNotEmpty) {
        try {
          _logger.finer('Body: ${utf8.decode(bytes)}');
        } catch (_) {
          _logger.finer('Body: <binary data>');
        }
      }

      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      _logger.severe('HTTP Error: $e', e);
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
