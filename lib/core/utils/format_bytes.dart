import 'dart:math';

String formatBytes(int bytes, {int decimals = 1}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  final i = (log(bytes) / log(1024)).floor();
  final clampedIndex = i.clamp(0, suffixes.length - 1);
  return '${(bytes / pow(1024, clampedIndex)).toStringAsFixed(decimals)} ${suffixes[clampedIndex]}';
}
