import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven_app/core/models/home_search_title_model.dart';

void main() {
  group('HomeSearchTitleModel', () {
    test('fromJson should correctly deserialize', () {
      final json = {
        'icon': {
          'codePoint': 984551,
          'fontFamily': 'MaterialIcons',
          'fontPackage': null,
        },
        'iconColor': '#ff9c27b0',
        'searchTitle': 'Best of the month',
      };

      final model = HomeSearchTitleModel.fromJson(json);

      expect(model.searchTitle, 'Best of the month');
      expect(model.icon.codePoint, 984551);
      expect(model.icon.fontFamily, 'MaterialIcons');
      expect(model.iconColor, const Color(0xff9c27b0));
    });

    test('toJson should correctly serialize', () {
      const model = HomeSearchTitleModel(
        icon: Icons.diamond_outlined,
        iconColor: Colors.purple,
        searchTitle: 'Best of the month',
      );

      final json = model.toJson();

      expect(json['searchTitle'], 'Best of the month');
      expect(json['icon']['codePoint'], Icons.diamond_outlined.codePoint);
      expect(json['iconColor'], '#ff9c27b0');
    });
  });
}
