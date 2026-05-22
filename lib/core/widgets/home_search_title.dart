import 'package:flutter/material.dart';
import 'package:haven_app/core/core.dart';

class HomeSearchTitle extends StatelessWidget {
  const HomeSearchTitle({
    required this.model,
    required this.onPressed,
    super.key,
  });

  final HomeSearchTitleModel model;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(model.icon, color: model.iconColor),
        const SizedBox(width: 10),
        Text(
          model.searchTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(child: Container()),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.more_horiz),
          label: const Text('More'),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0000EE),
          ),
        ),
      ],
    );
  }
}
