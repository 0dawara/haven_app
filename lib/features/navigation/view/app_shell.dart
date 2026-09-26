import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haven/core/utils/app_theme.dart';
import 'package:haven/l10n/l10n.dart';

const double kRailBreakpoint = 600;

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kRailBreakpoint) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (i) => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: AppTheme.cardColor,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.home_outlined),
                        selectedIcon: const Icon(Icons.home),
                        label: Text(context.l10n.navHome),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.favorite_border),
                        selectedIcon: const Icon(Icons.favorite),
                        label: Text(context.l10n.navSaved),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.person_outlined),
                        selectedIcon: const Icon(Icons.person),
                        label: Text(context.l10n.navProfile),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) => navigationShell.goBranch(
              i,
              initialLocation: i == navigationShell.currentIndex,
            ),
            backgroundColor: AppTheme.cardColor,
            indicatorColor: AppTheme.primaryPurple.withValues(alpha: 0.2),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: context.l10n.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_border),
                selectedIcon: const Icon(Icons.favorite),
                label: context.l10n.navSaved,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outlined),
                selectedIcon: const Icon(Icons.person),
                label: context.l10n.navProfile,
              ),
            ],
          ),
        );
      },
    );
  }
}
