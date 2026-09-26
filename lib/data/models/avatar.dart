import 'package:equatable/equatable.dart';

class Avatar extends Equatable {
  const Avatar({
    required this.px200,
    required this.px128,
    required this.px32,
    required this.px20,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
    px200: json['200px'] as String? ?? '',
    px128: json['128px'] as String? ?? '',
    px32: json['32px'] as String? ?? '',
    px20: json['20px'] as String? ?? '',
  );

  final String px200;
  final String px128;
  final String px32;
  final String px20;

  static const empty = Avatar(px200: '', px128: '', px32: '', px20: '');

  @override
  String toString() =>
      'Avatar(px200: $px200, px128: $px128, px32: $px32, px20: $px20)';

  Map<String, dynamic> toJson() => {
    'px200': px200,
    'px128': px128,
    'px32': px32,
    'px20': px20,
  };

  @override
  List<Object?> get props => [px200, px128, px32, px20];
}
