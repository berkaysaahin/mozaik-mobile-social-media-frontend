import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/states/post_state.dart';

class FollowingPage extends StatefulWidget {
  final ScrollController scrollController;
  const FollowingPage({super.key, required this.scrollController});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
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
              ),
            );
          }

          if (state is PostsCombinedState) {
            return _buildPostList(
              state.showingUserPosts ? state.userPosts : state.generalPosts,
              isShowingGeneralPosts: !state.showingUserPosts,
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else if (state is PostInitial || state is PostDeleted) {
            return const Center(child: Text('No posts available'));
          } else {
            return const Center(child: Text('No posts available'));
          }
        },
      ),
    );
  }

  Widget _buildPostList(List<Post> posts,
      {required bool isShowingGeneralPosts}) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          isShowingGeneralPosts ? 'No posts yet' : 'User has no posts',
        ),
      );
    }

    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (!isShowingGeneralPosts)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => context.read<PostBloc>().add(FetchPosts()),
                child: const Text('← Back to Following'),
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = posts[index];
              return Container(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPost(
                      userId: post.userId,
                      id: post.id,
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
                      music: post.music,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
            childCount: posts.length,
          ),
        ),
      ],
    );
  }
}
