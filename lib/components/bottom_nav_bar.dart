import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
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
      height: 64,
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
        iconSize: 26,
        enableFeedback: false,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? const Icon(FluentIcons.home_32_filled)
                : const Icon(FluentIcons.home_32_regular),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? const Icon(FluentIcons.search_32_filled)
                : const Icon(FluentIcons.search_32_regular),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? const Icon(CupertinoIcons.text_bubble_fill)
                : const Icon(CupertinoIcons.text_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.ashBlue,
              child: ClipOval(
                child: Image.network(
                  "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615",
                  width: 40, // Match the CircleAvatar size
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
