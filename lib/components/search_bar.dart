import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

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
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.platinum, width: 1),
      ),
      height: height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
