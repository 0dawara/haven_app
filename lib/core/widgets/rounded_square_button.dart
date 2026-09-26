import 'package:flutter/material.dart';

class RoundedSquareButton extends StatelessWidget {
  const RoundedSquareButton({
    required this.name,
    required this.icon,
    this.action,
    super.key,
  });

  final String name;
  final IconData icon;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white24,
            elevation: 0,
            fixedSize: Size(
              MediaQuery.of(context).size.height / 11,
              MediaQuery.of(context).size.height / 11,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: action,
          child: Center(child: Icon(icon, color: Colors.white, size: 30)),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
