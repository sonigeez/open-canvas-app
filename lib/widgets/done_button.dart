import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  final VoidCallback onTap;

  const DoneButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey("done button"),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.transparent,
        child: const Text(
          "Done",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
