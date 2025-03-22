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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.platinum,
            width: 0.5,
          ),
        ),
      ),
      height: 68,
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
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.7),
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
            ),
            _buildBottomNavBarItem(
              iconPath: 'assets/svg/search.svg',
              filledIconPath: 'assets/svg/search_fill.svg',
              label: 'Search',
              isSelected: currentIndex == 1,
            ),
            _buildBottomNavBarItem(
              iconPath: 'assets/svg/message.svg',
              filledIconPath: 'assets/svg/message_fill.svg',
              label: 'Messages',
              isSelected: currentIndex == 2,
            ),
            _buildBottomNavBarItem(
              icon: profileIcon, // Use the pre-built profile icon
              label: 'Profile',
              isSelected: currentIndex == 3,
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
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.7),
            ),
          if (icon != null) icon,
        ],
      ),
      label: label,
    );
  }
}
