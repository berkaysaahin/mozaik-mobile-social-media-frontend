import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../states/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (authContext, authState) {
        if (authState is Authenticated) {
          return const _ProfileContent();
        } else if (authState is Unauthenticated) {
          return const Center(child: Text('Please sign in'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => __ProfileContentState();
}

class __ProfileContentState extends State<_ProfileContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<PostBloc>().add(ClearUserPosts());
        context.read<PostBloc>().add(FetchPostsByUser(authState.user.userId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                final user = authState.user;
                return SliverAppBar(
                  expandedHeight: 180,
                  collapsedHeight: 0,
                  toolbarHeight: 0,
                  pinned: true,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? AppColors.background
                          : AppColors.backgroundDark,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Column(
                          children: [
                            CachedNetworkImage(
                                imageUrl: user.cover,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 140,
                                placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Text(""),
                                    )),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.background
                                    : AppColors.backgroundDark,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 80),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        left: 2,
                                        child: Container(
                                          width: 84,
                                          height: 84,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? AppColors.background
                                                    : AppColors.backgroundDark,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: ClipOval(
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: OverflowBox(
                                              maxWidth: 84,
                                              maxHeight: 84,
                                              child: CachedNetworkImage(
                                                imageUrl: user.profilePic,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 150),
                                  child: Row(
                                    children: [
                                      RoundedRectangleButton(
                                        elevation: 0,
                                        text: 'Edit',
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/editProfile'),
                                        backgroundColor: Theme.of(context)
                                                    .brightness ==
                                                Brightness.light
                                            ? Color.lerp(
                                                Colors.white, Colors.grey, 0.2)
                                            : Color.lerp(Colors.black,
                                                Colors.white, 0.2),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                                    .brightness ==
                                                Brightness.light
                                            ? Color.lerp(
                                                Colors.white, Colors.grey, 0.2)
                                            : Color.lerp(Colors.black,
                                                Colors.white, 0.2),
                                        radius: 18,
                                        child: Icon(
                                          FluentIcons
                                              .more_horizontal_32_regular,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
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
              } else if (authState is Unauthenticated) {
                return SliverAppBar(
                  expandedHeight: 180,
                  flexibleSpace: Center(
                    child: Text("Log in to see your profile"),
                  ),
                );
              } else {
                return const SliverAppBar(
                  expandedHeight: 180,
                  flexibleSpace: Center(
                    child: Text('No user data available.'),
                  ),
                );
              }
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                final user = authState.user;
                return BlocBuilder<PostBloc, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoading) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    } else if (postState is PostsCombinedState) {
                      final posts = postState.viewedUserPosts;
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            padding: const EdgeInsets.only(top: 22),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.background
                                  : AppColors.backgroundDark,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            user.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '@${user.handle}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        user.bio ?? 'No bio available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _buildStatItem(context,
                                              user.followers, 'Followers'),
                                          const SizedBox(width: 16),
                                          _buildStatItem(context,
                                              user.following, 'Following'),
                                          const SizedBox(width: 16),
                                          _buildStatItem(
                                              context, posts.length, 'Posts'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          ...posts.map((post) => Container(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.background
                                    : AppColors.backgroundDark,
                                child: Column(
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
                                      imageUrl: post.imageUrl,
                                      music: post.music,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              )),
                        ]),
                      );
                    } else if (postState is PostError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(postState.message),
                        ),
                      );
                    } else {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text('No posts available.'),
                        ),
                      );
                    }
                  },
                );
              } else {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, int count, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
