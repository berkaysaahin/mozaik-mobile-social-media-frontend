import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/music_card.dart';
import 'package:mozaik/components/post_button.dart';

class TextPost extends StatefulWidget {
  final String username;
  final String handle;
  final String content;
  final int likeCount;
  final int reblogCount;
  final int comments;
  final DateTime timestamp;
  final String profilePic;
  final bool hasLiked;
  final bool hasReblogged;
  final Map<String, dynamic>? music;

  const TextPost(
      {super.key,
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
      this.music});

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
    _likes = widget.likeCount;
    _isLiked = widget.hasLiked;
    _shares = widget.reblogCount;
    _isShared = widget.hasReblogged;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  void _toggleShare() {
    setState(() {
      _isShared = !_isShared;
      _shares += _isShared ? 1 : -1;
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                const Spacer(),
                PopupMenuButton<String>(
                  color: AppColors.background,
                  icon: const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                    } else if (value == 'delete') {
                    } else if (value == 'share') {}
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'share',
                        child: Text('Share'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    letterSpacing: 0.4,
                  ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            // SizedBox(
            //   width: double.infinity,
            //   height: 240,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(
            //         24),
            //     child: Image.network(
            //       'https://i.pinimg.com/736x/35/90/0a/35900a67651dfc54e4f60ca342dfc746.jpg',
            //       width: 120,
            //       height: 120,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            if (widget.music != null) MusicCard(music: widget.music),
            const SizedBox(height: 4),
            Row(
              children: [
                PostButton(
                  icon: CupertinoIcons.bubble_left,
                  count: widget.comments,
                  onTap: () {},
                ),
                const SizedBox(
                  width: 8,
                ),
                PostButton(
                  icon: CupertinoIcons.arrow_2_squarepath,
                  color: _isShared ? AppColors.primary : Colors.grey,
                  count: _shares,
                  onTap: _toggleShare,
                ),
                const SizedBox(
                  width: 8,
                ),
                PostButton(
                  icon: _isLiked
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: _isLiked ? Colors.red : Colors.grey,
                  count: _likes,
                  onTap: _toggleLike,
                ),
                const Spacer(),
                IconButton(
                  color: Colors.grey,
                  iconSize: 20,
                  icon: const Icon(CupertinoIcons.paperplane),
                  onPressed: () {},
                ),
              ],
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
