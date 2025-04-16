import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/profile_bloc.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mozaik/states/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context
        .read<PostBloc>()
        .add(const FetchPostsByUser('b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoading) {
                  return SliverAppBar(
                    expandedHeight: 180,
                    flexibleSpace: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                } else if (profileState is ProfileLoaded) {
                  final user = profileState.user;
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
                          // Cover image with gradient overlay
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
                                    const Icon(Icons.error),
                              ),
                              // This container ensures no gap between cover and profile info
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

                          // Gradient overlay for cover imager
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

                          // Profile picture and menu button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Profile picture
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 80),
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(44),
                                      border: Border.all(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? AppColors.background
                                            : AppColors.backgroundDark,
                                        width: 4,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(user.profilePic),
                                        fit: BoxFit.cover, // This makes the image cover the entire circle
                                      ),
                                    ),
                                  ),
                                ),

                                // Menu button
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 150), // Matches avatar position
                                    child: CircleAvatar(
                                      backgroundColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                          ? Color.lerp(Colors.white,
                                          Colors.grey, 0.2)
                                          : Color.lerp(Colors.black,
                                          Colors.white, 0.2),
                                      radius: 18,
                                      child: Icon(
                                        FluentIcons.more_horizontal_32_regular,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
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
                } else if (profileState is ProfileError) {
                  return SliverAppBar(
                    expandedHeight: 180,
                    flexibleSpace: Center(
                      child: Text(profileState.message),
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

            // Profile information and posts
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoaded) {
                  final user = profileState.user;
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
                        final posts = postState.userPosts;
                        return SliverList(
                          delegate: SliverChildListDelegate([
                            // Profile information section
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 22), // Accounts for avatar overlap
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                            height:
                                                8), // Space between avatar and name

                                        // Username and handle
                                        Row(
                                          children: [
                                            Text(
                                              user.username,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            const SizedBox(
                                                width: 8), // Increased from 6
                                            Text(
                                              '@${user.handle}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                            height: 12), // Space before bio

                                        // Bio
                                        Text(
                                          "I can't ever talk about this DNA!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          maxLines: 2,
                                        ),

                                        const SizedBox(
                                            height: 16), // Space before stats

                                        // Stats row
                                        Row(
                                          children: [
                                            _buildStatItem('8', 'Followers'),
                                            const SizedBox(
                                                width: 16), // Increased spacing
                                            _buildStatItem('12', 'Following'),
                                            const SizedBox(width: 16),
                                            _buildStatItem('3', 'Posts'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 16), // Space before posts
                                ],
                              ),
                            ),

                            // Posts list
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
                                      const SizedBox(
                                          height: 8),
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
      ),
    );
  }

  // Helper widget for consistent stat items
  Widget _buildStatItem(String count, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
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
