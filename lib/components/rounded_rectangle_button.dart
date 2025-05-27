import 'package:flutter/material.dart';

class RoundedRectangleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final double fontSize;
  final FontWeight fontWeight;

  const RoundedRectangleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 32.0,
    this.elevation = 1.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: elevation,
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
