import 'dart:ui';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${intAlpha.toRadixString(16).padLeft(2, '0')}'
      '${intRed.toRadixString(16).padLeft(2, '0')}'
      '${intGreen.toRadixString(16).padLeft(2, '0')}'
      '${intBlue.toRadixString(16).padLeft(2, '0')}';
}

extension IntColorComponents on Color {
  int get intAlpha => _floatToInt8(a);
  int get intRed => _floatToInt8(r);
  int get intGreen => _floatToInt8(g);
  int get intBlue => _floatToInt8(b);

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
