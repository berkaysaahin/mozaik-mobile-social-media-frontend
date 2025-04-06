import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/search_bar.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? AppColors.background
          : AppColors.backgroundDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomSearchBar(),
          ],
        ),
      ),
    );
  }
}
