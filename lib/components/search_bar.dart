import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final double height;
  final double borderRadius;

  const CustomSearchBar({
    super.key,
    this.hintText = "Lost? Try searching for something…",
    this.height = 36,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).brightness == Brightness.light
            ? Color.lerp(Colors.white, Colors.grey, 0.2)
            : Color.lerp(Colors.black, Colors.white, 0.2),
      ),
      height: height,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
