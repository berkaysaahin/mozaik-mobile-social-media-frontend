import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/components/notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
    );
  }
}
