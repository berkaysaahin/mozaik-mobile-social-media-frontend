import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String title;
  final VoidCallback? onLeftIconTap;
  final VoidCallback? onRightIconTap;

  const CustomAppBar({
    super.key,
    this.leftIcon,
    this.rightIcon,
    required this.title,
    this.onLeftIconTap,
    this.onRightIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.platinum,
            width: 0.5,
          ),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: leftIcon != null
            ? IconButton(
                icon: leftIcon!,
                onPressed: onLeftIconTap,
              )
            : null,
        actions: [
          if (rightIcon != null)
            IconButton(
              icon: rightIcon!,
              onPressed: onRightIconTap,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
