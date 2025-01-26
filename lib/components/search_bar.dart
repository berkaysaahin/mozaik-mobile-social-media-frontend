import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.platinum, width: 1),
      ),
      width: double.infinity,
      height: 36,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Lost? Try searching for something…",
            style: TextStyle(
              fontWeight: FontWeight.w100,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
