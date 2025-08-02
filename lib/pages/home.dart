import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/like_bloc.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/states/like_state.dart';
import 'package:mozaik/states/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _precachedUrls = [];

  @override
  void initState() {
    context.read<PostBloc>().add(FetchPosts());
    super.initState();
  }

  void _precacheImages(List<Post> posts, BuildContext context) {
    if (!mounted) return;

    final postsToPrecache = posts.take(3);
    for (final post in postsToPrecache) {
      try {
        if (post.imageUrl != null && !_precachedUrls.contains(post.imageUrl)) {
          precacheImage(CachedNetworkImageProvider(post.imageUrl!), context);
          _precachedUrls.add(post.imageUrl!);
        }
        if (post.music?['cover_art'] != null &&
            !_precachedUrls.contains(post.music!['cover_art'])) {
          precacheImage(
              CachedNetworkImageProvider(post.music!['cover_art']), context);
          _precachedUrls.add(post.music!['cover_art']);
        }
      } catch (e) {
        debugPrint('Failed to precache image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      strokeWidth: 3,
      onRefresh: () async {
        context.read<PostBloc>().add(FetchPosts());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: BlocListener<LikeBloc, LikeState>(
        listener: (context, likeState) {
          if (likeState is LikeUpdated) {
            final postId = likeState.postId;
            final liked = likeState.hasLiked;
            final likeCount = likeState.likeCount;

            final postBloc = context.read<PostBloc>();
            final currentState = postBloc.state;
            if (currentState is PostsCombinedState) {
              final updatedPosts = currentState.generalPosts.map((post) {
                if (post.id == postId) {
                  return post.copyWith(
                    hasLiked: liked,
                    likeCount: likeCount,
                  );
                }
                return post;
              }).toList();

              postBloc.add(UpdatePosts(updatedPosts));
            }
          }
        },
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostsCombinedState) {
              final posts = state.generalPosts;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _precacheImages(posts, context);
                }
              });

              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        return Container(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? AppColors.background
                                  : AppColors.backgroundDark,
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
                                music: post.music,
                                imageUrl: post.imageUrl,
                              ),
                              const SizedBox(height: 8),
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
      ),
    );
  }
}
