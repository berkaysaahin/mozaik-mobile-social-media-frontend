import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mozaik/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Widget profileIcon;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.profileIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.backgroundDark
        : AppColors.background;
    final primaryColor = Theme.of(context).primaryColor;
    final unselectedColor = primaryColor.withValues(alpha: 0.7);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.background
            : AppColors.backgroundDark,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 0.1,
          ),
        ),
      ),
      height: 80,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            textBaseline: TextBaseline.alphabetic,
          ),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: primaryColor,
          unselectedItemColor: unselectedColor,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.background
              : AppColors.backgroundDark,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          enableFeedback: false,
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            _buildBottomNavBarItem(
              iconPath: 'assets/svg/home.svg',
              filledIconPath: 'assets/svg/home_fill.svg',
              label: 'Home',
              isSelected: currentIndex == 0,
              selectedColor: primaryColor,
              unselectedColor: unselectedColor,
            ),
            _buildBottomNavBarItem(
              iconPath: 'assets/svg/search.svg',
              filledIconPath: 'assets/svg/search_fill.svg',
              label: 'Search',
              isSelected: currentIndex == 1,
              selectedColor: primaryColor,
              unselectedColor: unselectedColor,
            ),
            _buildBottomNavBarItem(
              iconPath: 'assets/svg/message.svg',
              filledIconPath: 'assets/svg/message_fill.svg',
              label: 'Messages',
              isSelected: currentIndex == 2,
              selectedColor: primaryColor,
              unselectedColor: unselectedColor,
            ),
            _buildBottomNavBarItem(
              icon: profileIcon,
              label: 'Profile',
              isSelected: currentIndex == 3,
              selectedColor: primaryColor,
              unselectedColor: unselectedColor,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavBarItem({
    String? iconPath,
    String? filledIconPath,
    Widget? icon,
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null && filledIconPath != null)
            SvgPicture.asset(
              isSelected ? filledIconPath : iconPath,
              height: 26,
              width: 26,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          if (icon != null) icon,
        ],
      ),
      label: label,
    );
  }
}
