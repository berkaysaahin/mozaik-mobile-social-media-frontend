import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Icon? leftIcon;
  final Widget? rightWidget;
  final Widget? customWidget;
  final String? title;
  final Function(BuildContext)? onLeftIconTap;
  final Function(BuildContext)? onRightWidgetTap;
  final int? selectedIndex;
  final TabController? tabController;
  final ValueNotifier<bool>? isTabBarVisibleNotifier;

  const CustomAppBar({
    super.key,
    this.leftIcon,
    this.rightWidget,
    this.title,
    this.onLeftIconTap,
    this.onRightWidgetTap,
    this.selectedIndex,
    this.tabController,
    this.isTabBarVisibleNotifier,
    this.customWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.background
          : AppColors.backgroundDark,
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
              style: Theme.of(context).textTheme.titleLarge
            ),
          if (customWidget != null) customWidget!,
        ],
      ),
      centerTitle: true,
      actions: [
        if (rightWidget != null)
          rightWidget is Icon
              ? IconButton(
                  icon: rightWidget as Icon,
                  onPressed: () {
                    if (onRightWidgetTap != null) {
                      onRightWidgetTap!(context);
                    }
                  },
                )
              : TextButton(
                  onPressed: () {
                    if (onRightWidgetTap != null) {
                      onRightWidgetTap!(context);
                    }
                  },
                  child: rightWidget!,
                ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
