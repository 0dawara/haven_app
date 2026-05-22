import 'package:equatable/equatable.dart';

class Thumbs extends Equatable {
  const Thumbs({
    required this.large,
    required this.original,
    required this.small,
  });

  factory Thumbs.fromJson(Map<String, dynamic> json) => Thumbs(
    large: json['large'] == null ? '' : json['large'] as String,
    original: json['original'] == null ? '' : json['original'] as String,
    small: json['small'] == null ? '' : json['small'] as String,
  );

  final String large;
  final String original;
  final String small;

  static const empty = Thumbs(large: '', original: '', small: '');

  Map<String, dynamic> toJson() => {
    'large': large,
    'original': original,
    'small': small,
  };

  @override
  List<Object?> get props => [large, original, small];

  @override
  String toString() =>
      'Thumbs(large: $large, original: $original, small: $small)';
}
