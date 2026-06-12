import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Centralized logger for the application.
class AppLogger {
  /// Initializes the logging system.
  static void init() {
    Logger.root.level = kDebugMode ? Level.INFO : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      dev.log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  /// Returns a [Logger] with the specified [name].
  static Logger getLogger(String name) => Logger(name);
}
