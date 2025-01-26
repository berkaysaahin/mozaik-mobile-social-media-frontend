import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
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
      height: 76,
      alignment: Alignment.topCenter,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            textBaseline: TextBaseline.alphabetic),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: AppColors.charcoal,
        unselectedItemColor: AppColors.charcoal,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        enableFeedback: false,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? const Icon(FluentIcons.home_24_filled)
                : const Icon(FluentIcons.home_24_regular),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? const Icon(FluentIcons.search_24_filled)
                : const Icon(FluentIcons.search_24_regular),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? const Icon(FluentIcons.chat_24_filled)
                : const Icon(FluentIcons.chat_24_regular),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? const Icon(FluentIcons.alert_24_filled)
                : const Icon(FluentIcons.alert_24_regular),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? const Icon(FluentIcons.person_24_filled)
                : const Icon(FluentIcons.person_24_regular),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
