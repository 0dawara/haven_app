import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/models/wallpaper_query.dart';

void main() {
  group('WallpaperQuery', () {
    test('fromJson(toJson()) round-trip with sorting: hot, page: 3', () {
      const query = WallpaperQuery(
        query: 'nature',
        sorting: WallpaperSorting.hot,
        page: 3,
      );
      final json = query.toJson();
      final roundTrip = WallpaperQuery.fromJson(json);

      expect(roundTrip, equals(query));
      expect(roundTrip.sorting, WallpaperSorting.hot);
      expect(roundTrip.page, 3);
      expect(roundTrip.query, 'nature');
    });

    test('handles legacy payload with string page, apikey, and bitstrings', () {
      final legacy = {
        'page': '2',
        'apikey': 'x',
        'sorting': 'hot',
        'purity': '110',
      };
      final parsed = WallpaperQuery.fromJson(legacy);

      expect(parsed.page, 2);
      expect(parsed.sorting, WallpaperSorting.hot);
      expect(parsed.purity, [true, true, false]);
      expect(parsed.category, [true, true, false]);
    });

    test('garbage categories fallback to defaults', () {
      final garbage = {'categories': '1x'};
      final parsed = WallpaperQuery.fromJson(garbage);

      expect(parsed.category, [true, true, false]);
      expect(parsed.purity, [true, false, false]);
      expect(parsed.sorting, WallpaperSorting.toplist);
      expect(parsed.order, WallpaperOrder.desc);
      expect(parsed.topRange, WallpaperTopRange.month);
      expect(parsed.page, 1);
    });

    test('toQueryParameters includes topRange only for toplist and no apikey', () {
      const toplistQuery = WallpaperQuery(
        query: 'space',
        sorting: WallpaperSorting.toplist,
        topRange: WallpaperTopRange.week,
      );
      final toplistParams = toplistQuery.toQueryParameters();
      expect(toplistParams['topRange'], '1w');
      expect(toplistParams['q'], 'space');
      expect(toplistParams.containsKey('apikey'), isFalse);

      const hotQuery = WallpaperQuery(
        query: '',
        sorting: WallpaperSorting.hot,
      );
      final hotParams = hotQuery.toQueryParameters();
      expect(hotParams.containsKey('topRange'), isFalse);
      expect(hotParams.containsKey('q'), isFalse);
      expect(hotParams.containsKey('apikey'), isFalse);
      expect(hotParams['sorting'], 'hot');
    });
  });
}
