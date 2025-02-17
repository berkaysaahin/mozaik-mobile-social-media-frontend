import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.ashBlue,
                  child: ClipOval(
                    child: Image.network(
                      profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            handle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${timestamp.difference(DateTime.now()).inHours.abs()}h',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          content,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.5,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 52,
                      height: 36,
                      child: Center(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FluentIcons.heart_16_regular,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                likes.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52,
                      height: 36,
                      child: Center(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FluentIcons.arrow_repeat_all_16_regular,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                retweets.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52,
                      height: 36,
                      child: Center(
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FluentIcons.chat_16_regular,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                comments.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.arrow_right_16_regular),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
