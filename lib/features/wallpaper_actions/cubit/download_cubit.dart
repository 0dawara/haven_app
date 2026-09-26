import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haven/data/data.dart';
import 'package:logging/logging.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit(this._repository) : super(const DownloadPreparing());

  final WallpaperActionsRepository _repository;
  static final _logger = Logger('DownloadCubit');
  StreamSubscription<DownloadUpdate>? _subscription;

  void start(String url) {
    _subscription?.cancel();
    _subscription = _repository.download(url).listen(
      (update) {
        switch (update) {
          case DownloadReceiving(:final received, :final total):
            emit(DownloadInProgress(received: received, total: total));
          case DownloadCompleted(:final path, :final alreadyExisted):
            emit(DownloadSuccess(path: path, alreadyExisted: alreadyExisted));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (error is DownloadPermissionDeniedException) {
          emit(const DownloadFailure(DownloadFailureReason.permissionDenied));
        } else if (error is DownloadUnsupportedPlatformException) {
          emit(const DownloadFailure(DownloadFailureReason.unsupportedPlatform));
        } else {
          _logger.severe('Download failed', error, stackTrace);
          emit(const DownloadFailure(DownloadFailureReason.network));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
