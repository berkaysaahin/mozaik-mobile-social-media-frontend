import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Text('Discover Page'),
      ),
    );
  }
}
