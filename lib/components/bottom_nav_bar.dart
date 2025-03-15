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
          textBaseline: TextBaseline.alphabetic,
        ),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.black38,
        unselectedItemColor: Colors.black38,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 22,
        enableFeedback: false,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          _buildBottomNavBarItem(
            icon: Icon(FluentIcons.home_24_regular),
            label: 'Home',
            isSelected: currentIndex == 0,
          ),
          _buildBottomNavBarItem(
            icon: Icon(FluentIcons.search_24_regular),
            label: 'Search',
            isSelected: currentIndex == 1,
          ),
          _buildBottomNavBarItem(
            icon: Icon(CupertinoIcons.text_bubble),
            label: 'Messages',
            isSelected: currentIndex == 2,
          ),
          _buildBottomNavBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.ashBlue,
              child: ClipOval(
                child: Image.network(
                  "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            label: 'Profile',
            isSelected: currentIndex == 3,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavBarItem({
    required Widget icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              icon,
              Transform.translate(
                offset: const Offset(0.5, 0.5),
                child: icon,
              ),
            ],
          ),
          if (isSelected && currentIndex != 3)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black38,
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
