import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class TextPost extends StatefulWidget {
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
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  late ValueNotifier<bool> _isLikedNotifier;
  late ValueNotifier<int> _likesNotifier;
  late ValueNotifier<bool> _isSharedNotifier;
  late ValueNotifier<int> _sharesNotifier;

  @override
  void initState() {
    super.initState();
    _isLikedNotifier = ValueNotifier(false);
    _likesNotifier = ValueNotifier(widget.likes);
    _isSharedNotifier = ValueNotifier(false);
    _sharesNotifier = ValueNotifier(widget.retweets);
  }

  void _toggleLike() {
    _isLikedNotifier.value = !_isLikedNotifier.value;
    _likesNotifier.value += _isLikedNotifier.value ? 1 : -1;
  }

  void _toggleShare() {
    _isSharedNotifier.value = !_isSharedNotifier.value;
    _sharesNotifier.value += _isSharedNotifier.value ? 1 : -1;
  }

  @override
  void dispose() {
    _isLikedNotifier.dispose();
    _likesNotifier.dispose();
    _isSharedNotifier.dispose();
    _sharesNotifier.dispose();
    super.dispose();
  }

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.ashBlue,
                  child: ClipOval(
                    child: Image.network(
                      widget.profilePic,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          '@${widget.handle}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTimestamp(widget.timestamp),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.content,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: CupertinoIcons.bubble_left,
                    count: widget.comments,
                    onTap: () {},
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isSharedNotifier,
                    builder: (context, isShared, child) {
                      return _buildActionButton(
                        icon: CupertinoIcons.arrow_2_squarepath,
                        color: isShared ? AppColors.primary : Colors.grey,
                        count: _sharesNotifier.value,
                        onTap: _toggleShare,
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLikedNotifier,
                    builder: (context, isLiked, child) {
                      return _buildActionButton(
                        icon: isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: isLiked ? Colors.red : Colors.grey,
                        count: _likesNotifier.value,
                        onTap: _toggleLike,
                      );
                    },
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

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color ?? Colors.grey),
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
