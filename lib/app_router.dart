import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haven/data/data.dart';
import 'package:haven/features/navigation/view/app_shell.dart';
import 'package:haven/features/saved_wallpapers/view/downloaded_wallpaper_page.dart';
import 'package:haven/features/saved_wallpapers/view/save_page.dart';
import 'package:haven/features/settings/view/settings_page.dart';
import 'package:haven/features/wallpaper_details/cubit/details_cubit.dart';
import 'package:haven/features/wallpaper_details/view/wallpaper_details_page.dart';
import 'package:haven/features/wallpaper_search/view/home_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const saved = '/saved';
  static const settings = '/settings';
  static String wallpaper(String id) => '/wallpaper/$id';
  static String savedFile(String path) =>
      Uri(path: '/saved/file', queryParameters: {'path': path}).toString();
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    onException: (_, _, router) => router.go(AppRoutes.home),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'wallpaper/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BlocProvider(
                        create: (c) =>
                            DetailsCubit(c.read<WallhavenRepository>(), id: id)
                              ..fetch(),
                        child: WallpaperDetailsPage(
                          id: id,
                          url: state.extra as String?,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.saved,
                builder: (context, state) => const SavePage(),
                routes: [
                  GoRoute(
                    path: 'file',
                    parentNavigatorKey: _rootNavigatorKey,
                    redirect: (context, state) {
                      final path = state.uri.queryParameters['path'];
                      if (path == null || path.isEmpty) return AppRoutes.saved;
                      return null;
                    },
                    builder: (context, state) => DownloadedWallpaperPage(
                      file: File(state.uri.queryParameters['path']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
