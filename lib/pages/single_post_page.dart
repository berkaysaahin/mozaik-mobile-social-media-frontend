import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/music_card.dart';
import 'package:mozaik/components/post_button.dart';

class SinglePostPage extends StatefulWidget {
  final String coverArt;
  final String trackName;
  final String artist;
  final String description;
  final int likes;
  final int commentsCount;
  final String username;
  final String userHandle;
  final String userAvatar;
  final int postId;
  final DateTime timestamp;

  const SinglePostPage({
    super.key,
    required this.coverArt,
    required this.trackName,
    required this.artist,
    required this.description,
    required this.likes,
    required this.commentsCount,
    required this.username,
    required this.userHandle,
    required this.userAvatar,
    required this.postId,
    required this.timestamp,
  });

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];
  bool _isLoadingComments = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _comments.addAll([
        {
          'id': '1',
          'user': 'music_lover42',
          'avatar': 'https://randomuser.me/api/portraits/women/34.jpg',
          'text': 'This track is amazing! Been listening on repeat all day.',
          'time': '2h ago',
          'likes': 24,
        },
        {
          'id': '2',
          'user': 'dj_enthusiast',
          'avatar': 'https://randomuser.me/api/portraits/men/22.jpg',
          'text': 'The production quality is outstanding. Who produced this?',
          'time': '1h ago',
          'likes': 15,
        },
        {
          'id': '3',
          'user': 'sound_explorer',
          'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
          'text':
              'The melody reminds me of their earlier work but with a fresh twist.',
          'time': '45m ago',
          'likes': 8,
        },
      ]);
      _isLoadingComments = false;
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'user': 'current_user',
        'avatar': 'https://randomuser.me/api/portraits/men/41.jpg',
        'text': _commentController.text,
        'time': 'Just now',
        'likes': 0,
      });
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.background,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(widget.userAvatar),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '@${widget.userHandle}',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        formatTimestamp(widget.timestamp),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      if (widget.coverArt.isNotEmpty)
                        MusicCard(
                          music: {
                            'cover_art': widget.coverArt,
                            'track_name': widget.trackName,
                            'artist': widget.artist,
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PostButton(
                        icon: CupertinoIcons.bubble_left,
                        count: widget.commentsCount,
                        onTap: () {},
                      ),
                      PostButton(
                        icon: CupertinoIcons.arrow_2_squarepath,
                        count: 0,
                        onTap: () {},
                      ),
                      PostButton(
                        icon: CupertinoIcons.heart,
                        count: widget.likes,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.commentsCount} Comments',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
          _isLoadingComments
              ? const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  )),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final comment = _comments[index];
                      return _buildCommentItem(comment);
                    },
                    childCount: _comments.length,
                  ),
                ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.send_32_filled,
                color: AppColors.primary,
              ),
              onPressed: _addComment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment['avatar']),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['user'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time'],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment['text']),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, size: 18),
                      onPressed: () {},
                    ),
                    Text(comment['likes'].toString()),
                    const SizedBox(width: 16),
                    const Text('Reply'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
