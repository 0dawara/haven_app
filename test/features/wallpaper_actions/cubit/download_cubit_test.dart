import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/wallpaper_actions/cubit/download_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockWallpaperActionsRepository extends Mock
    implements WallpaperActionsRepository {}

void main() {
  group('DownloadCubit', () {
    late WallpaperActionsRepository repository;

    setUp(() {
      repository = MockWallpaperActionsRepository();
    });

    test('initial state is DownloadPreparing', () {
      final cubit = DownloadCubit(repository);
      expect(cubit.state, const DownloadPreparing());
    });

    blocTest<DownloadCubit, DownloadState>(
      'maps DownloadReceiving to DownloadInProgress with correct fraction',
      build: () {
        when(
          () => repository.download(any()),
        ).thenAnswer(
          (_) => Stream.value(
            const DownloadReceiving(received: 50, total: 100),
          ),
        );
        return DownloadCubit(repository);
      },
      act: (cubit) => cubit.start('https://example.com/test.jpg'),
      expect: () => [
        const DownloadInProgress(received: 50, total: 100),
      ],
      verify: (cubit) {
        final state = cubit.state as DownloadInProgress;
        expect(state.fraction, 0.5);
      },
    );

    blocTest<DownloadCubit, DownloadState>(
      'maps DownloadPermissionDeniedException to DownloadFailure(permissionDenied)',
      build: () {
        when(
          () => repository.download(any()),
        ).thenAnswer(
          (_) => Stream.error(DownloadPermissionDeniedException()),
        );
        return DownloadCubit(repository);
      },
      act: (cubit) => cubit.start('https://example.com/test.jpg'),
      expect: () => [
        const DownloadFailure(DownloadFailureReason.permissionDenied),
      ],
    );

    test('close cancels the download stream subscription and triggers onCancel',
        () async {
      final onCancelCompleter = Completer<void>();
      final controller = StreamController<DownloadUpdate>(
        onCancel: () => onCancelCompleter.complete(),
      );

      when(() => repository.download(any())).thenAnswer((_) => controller.stream);

      final cubit = DownloadCubit(repository);
      cubit.start('https://example.com/test.jpg');

      await cubit.close();

      expect(onCancelCompleter.isCompleted, isTrue);
      await controller.close();
    });
  });
}
