import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class TextPost extends StatelessWidget {
  final String username;
  final String handle;
  final String content;
  final int likes;
  final int retweets;
  final int comments;
  final DateTime timestamp;
  final String profilePic;

  const TextPost({
    super.key,
    required this.username,
    required this.handle,
    required this.content,
    required this.likes,
    required this.retweets,
    required this.comments,
    required this.timestamp,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.platinum,
            width: 0.6,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image and User Info in a Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.ashBlue,
                  child: ClipOval(
                    child: Image.network(
                      profilePic,
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          FluentIcons.person_16_regular,
                          size: 24,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Username, Handle, and Timestamp in a Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and Handle in a Row
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          '@$handle',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTimestamp(timestamp),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Post Content
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
            ),
            const SizedBox(
              height: 16,
            ),
            // Action Buttons in a Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: CupertinoIcons.bubble_left,
                    count: comments,
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: CupertinoIcons.arrow_2_squarepath,
                    count: retweets,
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: CupertinoIcons.heart,
                    count: likes,
                    onTap: () {},
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.arrow_right),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Action Button Widget
  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
