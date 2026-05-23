import 'package:flutter/material.dart';

extension IconSerialization on IconData {
  static IconData fromJson(Map<String, dynamic> json) {
    return IconData(
      json['codePoint'] as int,
      fontFamily: json['fontFamily'] as String,
      fontPackage: json['fontPackage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'codePoint': codePoint,
    'fontFamily': fontFamily,
    'fontPackage': fontPackage,
  };
}
