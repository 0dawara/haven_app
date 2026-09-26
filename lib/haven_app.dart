import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haven/app_router.dart';
import 'package:haven/core/core.dart';
import 'package:haven/data/api/logging_client.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven/features/settings/cubit/settings_cubit.dart';
import 'package:haven/features/wallpaper_search/cubit/search_cubit.dart';
import 'package:haven/l10n/l10n.dart';
import 'package:http/http.dart' as http;

class HavenApp extends StatelessWidget {
  const HavenApp({required this.wallhavenRepository, super.key});

  final WallhavenRepository wallhavenRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: wallhavenRepository),
        RepositoryProvider(create: (_) => WallpaperStorage()),
        RepositoryProvider(
          create: (c) => WallpaperActionsRepository(
            httpClient: LoggingClient(http.Client()),
            storage: c.read<WallpaperStorage>(),
          ),
          dispose: (r) => r.close(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (c) => SettingsCubit(c.read<WallhavenRepository>()),
          ),
          BlocProvider(
            create: (c) => SearchCubit(c.read<WallhavenRepository>()),
          ),
          BlocProvider(
            create: (c) =>
                SavedWallpapersCubit(c.read<WallpaperStorage>())..fetchWallpapers(),
          ),
        ],
        child: const HavenAppView(),
      ),
    );
  }
}

class HavenAppView extends StatefulWidget {
  const HavenAppView({super.key});

  @override
  State<HavenAppView> createState() => _HavenAppViewState();
}

class _HavenAppViewState extends State<HavenAppView> {
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: AppTheme.themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
    );
  }
}
