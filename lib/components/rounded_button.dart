import 'package:flutter/material.dart';

class AppRoundedButton extends StatelessWidget {
  final Color backgroundColor;
  final Function() onTap;
  final IconData iconData;
  final double size;

  const AppRoundedButton({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.backgroundColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white.withValues(alpha: 0.3),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              iconData,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
