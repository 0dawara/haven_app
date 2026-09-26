import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:haven/core/utils/app_logger.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  static final _logger = Logger('BlocObserver');

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.info('onChange(${bloc.runtimeType})');
    _logger.fine('State details: $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.severe('onError(${bloc.runtimeType})', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  AppLogger.init();
  final logger = Logger('Bootstrap');

  FlutterError.onError = (details) {
    logger.severe(
      details.exceptionAsString(),
      details.exception,
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.severe('Uncaught platform error', error, stack);
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  final supportDir = await getApplicationSupportDirectory();
  final supportBox = File(p.join(supportDir.path, 'hydrated_box.hive'));
  try {
    if (!supportBox.existsSync()) {
      final tempDir = await getTemporaryDirectory();
      final tempBox = File(p.join(tempDir.path, 'hydrated_box.hive'));
      if (tempBox.existsSync()) {
        await supportDir.create(recursive: true);
        await tempBox.copy(supportBox.path);
      }
    }
  } catch (e, s) {
    logger.warning(
      'Failed to migrate hydrated_box.hive from temp directory',
      e,
      s,
    );
  }

  try {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(supportDir.path),
    );
  } catch (e, s) {
    logger.warning(
      'Failed to build HydratedStorage with copied box, recreating storage',
      e,
      s,
    );
    if (supportBox.existsSync()) {
      try {
        await supportBox.delete();
      } catch (_) {}
    }
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(supportDir.path),
    );
  }

  runApp(await builder());
}
