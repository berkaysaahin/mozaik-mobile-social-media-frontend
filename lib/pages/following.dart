import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/states/post_state.dart';

class FollowingPage extends StatefulWidget {
  final ScrollController scrollController;
  const FollowingPage({super.key, required this.scrollController});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(FetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      strokeWidth: 3,
      onRefresh: () async {
        context.read<PostBloc>().add(FetchPosts());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ));
          } else if (state is PostsLoaded) {
            return CustomScrollView(
              controller: widget.scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = state.posts[index];
                      return Container(
                        color: AppColors.background,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextPost(
                                username: post.username,
                                handle: post.handle,
                                content: post.content,
                                likeCount: post.likeCount,
                                reblogCount: post.reblogCount,
                                hasLiked: post.hasLiked,
                                hasReblogged: post.hasReblogged,
                                comments: post.comments,
                                timestamp: post.timestamp,
                                profilePic: post.profilePic,
                                music: post.music),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                    childCount: state.posts.length,
                  ),
                ),
              ],
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No posts available'));
          }
        },
      ),
    );
  }
}
