import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haven_app/core/core.dart';
import 'package:haven_app/data/data.dart';
import 'package:haven_app/features/navigation/view/navigation_bar_page.dart';
import 'package:haven_app/features/saved_wallpapers/cubit/saved_wallpapers_cubit.dart';
import 'package:haven_app/features/settings/cubit/settings_cubit.dart';
import 'package:haven_app/features/wallpaper_actions/cubit/actions_cubit.dart';
import 'package:haven_app/features/wallpaper_details/cubit/details_cubit.dart';
import 'package:haven_app/features/wallpaper_search/cubit/search_cubit.dart';

class HavenApp extends StatelessWidget {
  const HavenApp({required this.wallhavenRepository, super.key});

  final WallhavenRepository wallhavenRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: wallhavenRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SearchCubit(wallhavenRepository)),
          BlocProvider(create: (_) => DetailsCubit(wallhavenRepository)),
          BlocProvider(create: (_) => SettingsCubit(wallhavenRepository)),
          BlocProvider(
            create: (_) => SavedWallpapersCubit()..fetchWallpapers(),
          ),
          RepositoryProvider(create: (_) => ActionsCubit()),
        ],
        child: const HavenAppView(),
      ),
    );
  }
}

class HavenAppView extends StatelessWidget {
  const HavenAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: const NavigationBarPage(),
    );
  }
}
