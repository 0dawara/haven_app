part of 'download_cubit.dart';

enum DownloadFailureReason {
  permissionDenied,
  unsupportedPlatform,
  network,
}

sealed class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

final class DownloadPreparing extends DownloadState {
  const DownloadPreparing();
}

final class DownloadInProgress extends DownloadState {
  const DownloadInProgress({required this.received, this.total});

  final int received;
  final int? total;

  double? get fraction =>
      total != null && total! > 0 ? received / total! : null;

  @override
  List<Object?> get props => [received, total];
}

final class DownloadSuccess extends DownloadState {
  const DownloadSuccess({
    required this.path,
    required this.alreadyExisted,
  });

  final String path;
  final bool alreadyExisted;

  @override
  List<Object?> get props => [path, alreadyExisted];
}

final class DownloadFailure extends DownloadState {
  const DownloadFailure(this.reason);

  final DownloadFailureReason reason;

  @override
  List<Object?> get props => [reason];
}
