import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon? leftIcon;
  final Icon? rightIcon;
  final Widget? customWidget;
  final String? title;
  final Function(BuildContext)? onLeftIconTap;
  final Function(BuildContext)? onRightIconTap;
  final int? selectedIndex;
  final TabController? tabController;
  final ValueNotifier<bool>? isTabBarVisibleNotifier;

  const CustomAppBar({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.title,
    this.onLeftIconTap,
    this.onRightIconTap,
    this.selectedIndex,
    this.tabController,
    this.isTabBarVisibleNotifier,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> effectiveNotifier =
        isTabBarVisibleNotifier ?? ValueNotifier(false);
    return ValueListenableBuilder<bool>(
      valueListenable: effectiveNotifier,
      builder: (context, isTabBarVisible, child) {
        return Container(
          decoration: !isTabBarVisible
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.platinum,
                      width: 1,
                    ),
                  ),
                )
              : null,
          child: AppBar(
            leading: leftIcon != null
                ? IconButton(
                    icon: leftIcon!,
                    onPressed: () {
                      if (onLeftIconTap != null) {
                        onLeftIconTap!(context);
                      }
                    },
                  )
                : null,
            title: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (customWidget != null) customWidget!,
              ],
            ),
            centerTitle: true,
            actions: [
              if (rightIcon != null)
                IconButton(
                  icon: rightIcon!,
                  onPressed: () {
                    if (onRightIconTap != null) {
                      onRightIconTap!(context);
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
