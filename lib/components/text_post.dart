import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/post_button.dart';

class TextPost extends StatefulWidget {
  final String username;
  final String handle;
  final String content;
  final int likeCount; // Updated: Like count from the backend
  final int reblogCount; // Updated: Reblog count from the backend
  final int comments;
  final DateTime timestamp;
  final String profilePic;
  final bool hasLiked; // Updated: Whether the current user has liked the post
  final bool
      hasReblogged; // Updated: Whether the current user has reblogged the post

  const TextPost({
    super.key,
    required this.username,
    required this.handle,
    required this.content,
    required this.likeCount,
    required this.reblogCount,
    required this.comments,
    required this.timestamp,
    required this.profilePic,
    required this.hasLiked,
    required this.hasReblogged,
  });

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  late int _likes;
  late bool _isLiked;
  late int _shares;
  late bool _isShared;

  @override
  void initState() {
    super.initState();
    _likes =
        widget.likeCount; // Initialize with the like count from the backend
    _isLiked =
        widget.hasLiked; // Initialize with the like status from the backend
    _shares =
        widget.reblogCount; // Initialize with the reblog count from the backend
    _isShared = widget
        .hasReblogged; // Initialize with the reblog status from the backend
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
    // Call your backend API to update the like status
  }

  void _toggleShare() {
    setState(() {
      _isShared = !_isShared;
      _shares += _isShared ? 1 : -1;
    });
    // Call your backend API to update the reblog status
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PostButton(
                    icon: CupertinoIcons.bubble_left,
                    count: widget.comments,
                    onTap: () {},
                  ),
                  PostButton(
                    icon: CupertinoIcons.arrow_2_squarepath,
                    color: _isShared ? AppColors.primary : Colors.grey,
                    count: _shares,
                    onTap: _toggleShare,
                  ),
                  PostButton(
                    icon: _isLiked
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: _isLiked ? Colors.red : Colors.grey,
                    count: _likes,
                    onTap: _toggleLike,
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
