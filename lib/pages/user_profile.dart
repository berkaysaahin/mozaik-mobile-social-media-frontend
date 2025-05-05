import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/rounded_button.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mozaik/states/user_state.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserById(widget.userId));
    context.read<PostBloc>().add(FetchPostsByUser(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoading) {
                  return SliverAppBar(
                    expandedHeight: 180,
                    flexibleSpace: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                } else if (userState is UserLoaded) {
                  final user = userState.user;
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
                                    const Icon(Icons.error),
                              ),
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
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: AppRoundedButton(
                              size: 36,
                              onTap: () {
                                context.read<PostBloc>().add(ClearUserPosts());
                                context.read<PostBloc>().add(FetchPosts());
                                context.read<PostBloc>().add(const FetchPostsByUser(
                                    'b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c')); //buraya dön!!
                                Navigator.pop(context);
                              },
                              iconColor:
                                  Theme.of(context).dialogBackgroundColor,
                              iconData: FluentIcons.arrow_left_12_regular,
                              backgroundColor: Theme.of(context).primaryColor,
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
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(44),
                                      border: Border.all(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? AppColors.background
                                            : AppColors.backgroundDark,
                                        width: 4,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            user.profilePic),
                                        fit: BoxFit.cover,
                                      ),
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
                                          text: 'Follow',
                                          onPressed: () {},
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? Color.lerp(Colors.white,
                                                      Colors.grey, 0.2)
                                                  : Color.lerp(Colors.black,
                                                      Colors.white, 0.2),
                                          textColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? Color.lerp(Colors.white,
                                                      Colors.grey, 0.2)
                                                  : Color.lerp(Colors.black,
                                                      Colors.white, 0.2),
                                          radius: 18,
                                          child: Icon(
                                            FluentIcons
                                                .more_horizontal_32_regular,
                                            color:
                                                Theme.of(context).primaryColor,
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
                } else if (userState is UserError) {
                  return SliverAppBar(
                    expandedHeight: 180,
                    flexibleSpace: Center(
                      child: Text(userState.message),
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
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded) {
                  final user = userState.user;
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
                            Container(
                              padding: const EdgeInsets.only(top: 22),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.background
                                    : AppColors.backgroundDark,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          "well this time I break, I will never live, another day",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            _buildStatItem('8', 'Followers'),
                                            const SizedBox(width: 16),
                                            _buildStatItem('12', 'Following'),
                                            const SizedBox(width: 16),
                                            _buildStatItem('3', 'Posts'),
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
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {},
        child: Icon(
          size: 28,
          FluentIcons.compose_12_regular,
          color: Theme.of(context).dialogBackgroundColor,
        ),
      ),
    );
  }

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
