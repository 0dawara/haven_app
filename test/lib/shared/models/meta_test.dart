import 'package:flutter_test/flutter_test.dart';

import 'package:haven_app/data/models/meta.dart';

void main() {
  group('Meta', () {
    group('fromJson', () {
      test('returns correct Meta object', () {
        expect(
          Meta.fromJson(const <String, dynamic>{
            'current_page': 1,
            'last_page': 147,
            'per_page': 24,
            'total': 3510,
            'query': null,
            'seed': null,
          }),
          isA<Meta>()
              .having((w) => w.currentPage, 'current_page', 1)
              .having((w) => w.lastPage, 'last_page', 147)
              .having((w) => w.perPage, 'per_page', 24)
              .having((w) => w.total, 'total', 3510)
              .having((w) => w.query, 'query', null)
              .having((w) => w.seed, 'seed', null),
        );
      });
    });
  });
}
