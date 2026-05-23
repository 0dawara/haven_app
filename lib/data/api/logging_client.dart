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
    _logger.finer('Headers: ${request.headers}');

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

      // We need to read the stream to log it, but that consumes it.
      // To allow downstream consumers to read it, we must recreate it.
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
