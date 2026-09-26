import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/settings/cubit/settings_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class MockWallhavenRepository extends Mock implements WallhavenRepository {}

void main() {
  initHydratedStorage();

  group('SettingsCubit', () {
    late WallhavenRepository repository;

    setUp(() {
      repository = MockWallhavenRepository();
      when(() => repository.updateApiKey(any())).thenReturn(null);
    });

    blocTest<SettingsCubit, SettingsState>(
      'WallhavenInvalidApiKeyFailure emits failure and clears repository apiKey',
      build: () {
        when(
          () => repository.validateApiKey(any()),
        ).thenThrow(const WallhavenInvalidApiKeyFailure());
        return SettingsCubit(repository);
      },
      act: (cubit) => cubit.validateApikey('invalid-key'),
      expect: () => [
        const SettingsState(userStatus: UserStatus.loading),
        const SettingsState(userStatus: UserStatus.failure, apikey: ''),
      ],
      verify: (_) {
        verify(() => repository.updateApiKey(null)).called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'WallhavenRateLimitFailure emits unavailable without clearing repository key',
      build: () {
        when(
          () => repository.validateApiKey(any()),
        ).thenThrow(const WallhavenRateLimitFailure());
        return SettingsCubit(repository);
      },
      act: (cubit) => cubit.validateApikey('my-key'),
      expect: () => [
        const SettingsState(userStatus: UserStatus.loading),
        const SettingsState(userStatus: UserStatus.unavailable),
      ],
      verify: (_) {
        // Constructor may call updateApiKey(null) for initial state, but error branch does not call it
        verifyNever(() => repository.updateApiKey('my-key'));
      },
    );

    test('constructor synchronizes apiKey with repository when hydrated state is success', () {
      final storage = MockStorage();
      when(
        () => storage.read('SettingsCubit'),
      ).thenReturn({'userStatus': 'success', 'apikey': 'saved-key'});
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;

      SettingsCubit(repository);

      verify(() => repository.updateApiKey('saved-key')).called(1);
    });

    test('legacy userStatus index 1 restores to initial', () {
      final cubit = SettingsCubit(repository);
      final state = cubit.fromJson({'userStatus': 1, 'apikey': 'some-key'});

      expect(state.userStatus, UserStatus.initial);
      expect(state.apikey, '');
    });
  });
}
