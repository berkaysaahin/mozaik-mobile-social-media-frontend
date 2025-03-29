import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/states/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<PostBloc>().add(FetchPosts());
    super.initState();
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
            return const SizedBox.shrink();
          } else if (state is PostsCombinedState) {
            final posts =
                state.showingUserPosts ? state.userPosts : state.generalPosts;

            return CustomScrollView(
              slivers: [
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
                                id: post.id,
                                username: post.username,
                                handle: post.handle,
                                content: post.content,
                                userId: post.userId,
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
                    childCount: posts.length,
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
