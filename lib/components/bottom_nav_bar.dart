import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/states/user_state.dart';

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
              icon: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoaded) {
                    return CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.ashBlue,
                      child: ClipOval(
                        child: Image.network(
                          state.user.profilePic,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else if (state is UserError) {
                    return const Icon(Icons.error);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              label: 'Profile',
              isSelected: currentIndex == 3,
            ),
          ],
        ),
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
          icon,
          if (isSelected && currentIndex != 3)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
