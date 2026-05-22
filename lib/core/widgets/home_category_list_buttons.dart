import 'package:flutter/material.dart';

class HomeCategoryListButtons extends StatelessWidget {
  const HomeCategoryListButtons({
    this.toplistOnPressed,
    this.latestOnPressed,
    this.hotOnPressed,
    this.randomOnPressed,
    super.key,
  });

  final VoidCallback? toplistOnPressed;
  final VoidCallback? latestOnPressed;
  final VoidCallback? hotOnPressed;
  final VoidCallback? randomOnPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2,
          padding: EdgeInsets.zero,
          children: [
            customButton(
              onPressed: toplistOnPressed,
              foregroundColor: Colors.purple,
              icon: Icons.diamond_outlined,
              label: 'Toplist',
            ),
            customButton(
              onPressed: hotOnPressed,
              foregroundColor: Colors.red,
              icon: Icons.local_fire_department_outlined,
              label: 'Hot',
            ),
            customButton(
              onPressed: latestOnPressed,
              foregroundColor: Colors.green,
              icon: Icons.schedule_outlined,
              label: 'Latest',
            ),
            customButton(
              onPressed: randomOnPressed,
              foregroundColor: Colors.orange,
              icon: Icons.shuffle_outlined,
              label: 'Random',
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget customButton({
    required VoidCallback? onPressed,
    required MaterialColor foregroundColor,
    required IconData icon,
    required String label,
  }) => TextButton.icon(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: foregroundColor[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),
    icon: Icon(icon, size: 36),
    label: Text(label, style: const TextStyle(fontSize: 20)),
  );
}
