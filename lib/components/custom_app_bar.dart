import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String title;
  final VoidCallback? onLeftIconTap;
  final VoidCallback? onRightIconTap;
  final int selectedIndex;
  final TabController? tabController;
  final ValueNotifier<bool> isTabBarVisibleNotifier;

  const CustomAppBar({
    super.key,
    this.leftIcon,
    this.rightIcon,
    required this.title,
    this.onLeftIconTap,
    this.onRightIconTap,
    required this.selectedIndex,
    this.tabController,
    required this.isTabBarVisibleNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTabBarVisibleNotifier,
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
            title: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.ashGray,
                child: ClipOval(
                  child: Image.network(
                    "https://pbs.twimg.com/profile_images/1805704376872300545/6Iatj0HI_400x400.jpg",
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
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
