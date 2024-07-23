import 'package:flutter/material.dart';

class BackgroundButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String? image;

  const BackgroundButton(
      {required this.onTap, super.key, required this.color, this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey("background button"),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(7).copyWith(right: 18),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.white, width: 3),
          image: image != null
              ? DecorationImage(
                  image: AssetImage(image!),
                  fit: BoxFit.cover,
                )
              : null,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
