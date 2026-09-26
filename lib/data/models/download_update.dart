sealed class DownloadUpdate {
  const DownloadUpdate();
}

final class DownloadReceiving extends DownloadUpdate {
  const DownloadReceiving({required this.received, this.total});

  final int received;
  final int? total;
}

final class DownloadCompleted extends DownloadUpdate {
  const DownloadCompleted({required this.path, required this.alreadyExisted});

  final String path;
  final bool alreadyExisted;
}
