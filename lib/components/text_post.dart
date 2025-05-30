import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/music_card.dart';
import 'package:mozaik/components/post_button.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/pages/single_post_page.dart';
import 'package:mozaik/pages/user_profile.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:shimmer/shimmer.dart';

class TextPost extends StatefulWidget {
  final String username;
  final String userId;
  final String handle;
  final String content;
  final int likeCount;
  final int reblogCount;
  final int id;
  final int comments;
  final DateTime timestamp;
  final String profilePic;
  final bool hasLiked;
  final bool hasReblogged;
  final String? imageUrl;
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
      this.music,
      required this.id,
      required this.userId,
      this.imageUrl});

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late int _likes;
  late bool _isLiked;
  late int _shares;
  late bool _isShared;
  bool _isDisposed = false;
  bool _initialLoadCompleted = false;
  bool _isBookmarked = false;
  int _bookmarks = 0;
  @override
  void initState() {
    super.initState();
    _likes = widget.likeCount;
    _isLiked = widget.hasLiked;
    _shares = widget.reblogCount;
    _isShared = widget.hasReblogged;

    final postBloc = context.read<PostBloc>();
    if (postBloc.state is PostsCombinedState) {
      final state = postBloc.state as PostsCombinedState;
      _initialLoadCompleted = state.loadedPostIds.contains(widget.id) ||
          state.visiblePosts.any((post) => post.id == widget.id);
    } else {
      _initialLoadCompleted = false;
    }

    if (!_initialLoadCompleted) {
      _loadPostData();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
      _bookmarks += _isBookmarked ? 1 : -1;
    });
  }

  Future<void> _loadPostData() async {
    if (!mounted) return;

    try {
      if (mounted) {
        context.read<PostBloc>().add(StartPostLoading(widget.id));
      }
      await Future.delayed(const Duration(milliseconds: 600));

      if (_isDisposed || !mounted) return;
      await Future.delayed(Duration(milliseconds: widget.id % 3 * 200));

      if (mounted) {
        context.read<PostBloc>().add(StopPostLoading(widget.id));
      }
    } catch (e) {
      if (mounted) {
        context.read<PostBloc>().add(StopPostLoading(widget.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        final isLoading = state is PostsCombinedState &&
            state.loadingPostIds.contains(widget.id);

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: _buildPostPlaceholder(),
          secondChild: _buildPostContent(),
        );
      },
    );
  }

  Widget _buildPostContent() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinglePostPage(
              coverArt: widget.music?['cover_art'] ?? '',
              trackName: widget.music?['track_name'] ?? '',
              artist: widget.music?['artist'] ?? '',
              description: widget.content,
              likes: _likes,
              commentsCount: widget.comments,
              username: widget.username,
              userHandle: widget.handle,
              userAvatar: widget.profilePic,
              postId: widget.id,
              timestamp: widget.timestamp,
              imageUrl: widget.imageUrl,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                context.read<PostBloc>().add(ClearUserPosts());
                context.read<PostBloc>().add(FetchPostsByUser(widget.userId));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfilePage(userId: widget.userId),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '@${widget.handle}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '·',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  formatTimestamp(widget.timestamp),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.background
                            : AppColors.backgroundDark,
                        icon: const Icon(
                          CupertinoIcons.ellipsis_vertical,
                          size: 18,
                          color: Colors.grey,
                        ),
                        onSelected: (value) {
                          final postId = widget.id;
                          if (value == 'edit') {
                          } else if (value == 'delete') {
                            context.read<PostBloc>().add(DeletePost(
                                  postId,
                                  imageUrl: widget.imageUrl,
                                ));
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
                  const SizedBox(height: 10),
                  Text(
                    widget.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 12),
                  if (widget.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (widget.music != null) ...[
                    MusicCard(music: widget.music),
                  ],
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PostButton(
                          icon: _isBookmarked
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                          color: _isBookmarked
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          count: _bookmarks,
                          onTap: _toggleBookmark,
                        ),
                        Spacer(),
                        PostButton(
                          icon: CupertinoIcons.bubble_left,
                          count: widget.comments,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SinglePostPage(
                                  coverArt: widget.music?['cover_art'] ?? '',
                                  trackName: widget.music?['track_name'] ?? '',
                                  artist: widget.music?['artist'] ?? '',
                                  description: widget.content,
                                  likes: _likes,
                                  commentsCount: widget.comments,
                                  username: widget.username,
                                  userHandle: widget.handle,
                                  userAvatar: widget.profilePic,
                                  postId: widget.id,
                                  timestamp: widget.timestamp,
                                  imageUrl: widget.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 24),
                        PostButton(
                          icon: CupertinoIcons.arrow_2_squarepath,
                          color: _isShared
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          count: _shares,
                          onTap: _toggleShare,
                        ),
                        const SizedBox(width: 24),
                        PostButton(
                          icon: _isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: _isLiked ? Colors.red : Colors.grey,
                          count: _likes,
                          onTap: _toggleLike,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const _ShimmerPostItem(),
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

class _ShimmerPostItem extends StatelessWidget {
  const _ShimmerPostItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.backgroundDark
                  : AppColors.background,
              width: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 180,
                              height: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
