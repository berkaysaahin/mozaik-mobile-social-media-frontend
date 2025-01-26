import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? customWidget;
  final String? title;
  final VoidCallback? onLeftIconTap;
  final VoidCallback? onRightIconTap;
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
            title: customWidget ??
                (title != null
                    ? Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.ashBlue,
                child: ClipOval(
                  child: Image.network(
                    "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              if (rightIcon != null)
                IconButton(
                  icon: rightIcon!,
                  onPressed: onRightIconTap,
                ),
              if (leftIcon != null)
                IconButton(
                  icon: leftIcon!,
                  onPressed: onLeftIconTap,
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
