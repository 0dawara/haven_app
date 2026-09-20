import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/core/models/home_search_title_model.dart';

void main() {
  group('HomeSearchTitleModel', () {
    test('fromJson restores the persisted variant', () {
      final model = HomeSearchTitleModel.fromJson({
        'variant': 'hot',
        'searchTitle': 'Hot',
      });

      expect(model.variant, HomeSearchTitleVariant.hot);
      expect(model.searchTitle, 'Hot');
      expect(model.icon, Icons.local_fire_department_outlined);
      expect(model.iconColor, Colors.red);
    });

    test('fromJson maps legacy payloads without a variant by title', () {
      final legacy = HomeSearchTitleModel.fromJson({
        'icon': {'codePoint': 984551, 'fontFamily': 'MaterialIcons'},
        'iconColor': '#ff9c27b0',
        'searchTitle': 'Best of the month',
      });

      expect(legacy.variant, HomeSearchTitleVariant.toplist);

      final legacyQuery = HomeSearchTitleModel.fromJson({
        'icon': {'codePoint': 57669, 'fontFamily': 'MaterialIcons'},
        'iconColor': '#ff9e9e9e',
        'searchTitle': 'anime',
      });

      expect(legacyQuery.variant, HomeSearchTitleVariant.search);
      expect(legacyQuery.searchTitle, 'anime');
    });

    test('toJson round-trips through fromJson', () {
      const model = HomeSearchTitleModel.search('nature');

      expect(model.toJson(), {'variant': 'search', 'searchTitle': 'nature'});
      expect(HomeSearchTitleModel.fromJson(model.toJson()), model);
    });
  });
}
