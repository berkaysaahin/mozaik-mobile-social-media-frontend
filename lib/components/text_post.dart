import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/music_card.dart';
import 'package:mozaik/components/post_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mozaik/events/post_event.dart';
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
      required this.userId});

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
          (state.showingUserPosts
              ? state.userPosts.any((post) => post.id == widget.id)
              : state.generalPosts.any((post) => post.id == widget.id));
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '@${widget.handle}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatTimestamp(widget.timestamp),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: AppColors.background,
                        icon: const Icon(
                          CupertinoIcons.ellipsis_vertical,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onSelected: (value) {
                          final postId = widget.id;
                          if (value == 'edit') {
                          } else if (value == 'delete') {
                            context.read<PostBloc>().add(DeletePost(postId));
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
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  if (widget.music != null) ...[
                    MusicCard(music: widget.music),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      IconButton(
                        iconSize: 20,
                        icon: SvgPicture.asset(
                          'assets/svg/send.svg',
                          height: 20,
                          width: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      PostButton(
                        icon: CupertinoIcons.bubble_left,
                        count: widget.comments,
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      PostButton(
                        icon: CupertinoIcons.arrow_2_squarepath,
                        color: _isShared ? AppColors.primary : Colors.grey,
                        count: _shares,
                        onTap: _toggleShare,
                      ),
                      const SizedBox(width: 16),
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: const Border(
            bottom: BorderSide(color: AppColors.platinum, width: 0.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
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
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 180,
                                height: 14,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.grey[300],
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
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.music != null)
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                            width: 24, height: 24, color: Colors.grey[300]),
                        const SizedBox(width: 16),
                        Container(
                            width: 24, height: 24, color: Colors.grey[300]),
                        const SizedBox(width: 16),
                        Container(
                            width: 24, height: 24, color: Colors.grey[300]),
                        const Spacer(),
                        Container(
                            width: 24, height: 24, color: Colors.grey[300]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
