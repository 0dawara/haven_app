import 'package:flutter/material.dart';
import 'package:haven_app/app/app.dart';
import 'package:haven_app/shared/utils/app_theme.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true, // Allow body to extend behind the FAB/Bar
      body: IndexedStack(
        index: currentPageIndex,
        children: const [HomePage(), SavePage(), UserPage()],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.cardColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              currentPageIndex == 0 ? Icons.home : Icons.home_outlined,
              'Home',
            ),
            _buildNavItem(
              1,
              currentPageIndex == 1 ? Icons.favorite : Icons.favorite_border,
              'Saved',
            ),
            _buildNavItem(
              2,
              currentPageIndex == 2 ? Icons.person : Icons.person_outlined,
              'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentPageIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentPageIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryPurple : Colors.grey,
            size: 26,
          ),
          if (isSelected)
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            const SizedBox(height: 14),
        ],
      ),
    );
  }
}
