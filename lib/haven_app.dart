import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven_app/app/app.dart';
import 'package:haven_app/shared/utils/app_theme.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

class HavenApp extends StatelessWidget {
  const HavenApp({required this.wallhavenRepository, super.key});

  final WallhavenRepository wallhavenRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: wallhavenRepository,
      child: BlocProvider(
        create: (_) => WallpaperCubit(wallhavenRepository),
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
