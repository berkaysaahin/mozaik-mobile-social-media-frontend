import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        onLeftIconTap: (BuildContext context) {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.platinum,
                  width: 0.6,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Inbox ',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            "8",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(FluentIcons.settings_20_regular),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: const [
                  CustomNotification(
                    title: 'Followers',
                    message: 'Followed you',
                    icon: FluentIcons.person_16_regular,
                  ),
                  CustomNotification(
                    title: 'Likes',
                    message: 'Liked your post',
                    icon: FluentIcons.heart_16_regular,
                  ),
                  CustomNotification(
                    title: 'Messages',
                    message: 'Your have a new message.',
                    icon: FluentIcons.chat_16_regular,
                  ),
                  CustomNotification(
                    title: 'Followers',
                    message: 'Followed you',
                    icon: FluentIcons.person_16_regular,
                  ),
                  CustomNotification(
                    title: 'Followers',
                    message: 'Followed you',
                    icon: FluentIcons.person_16_regular,
                  ),
                  CustomNotification(
                    title: 'Messages',
                    message: 'Your have a new message.',
                    icon: FluentIcons.chat_16_regular,
                  ),
                  CustomNotification(
                    title: 'Messages',
                    message: 'Your have a new message.',
                    icon: FluentIcons.chat_16_regular,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
