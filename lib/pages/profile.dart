import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mozaik/states/user_state.dart';

class ProfilePage extends StatefulWidget {
  final bool shouldFetchUser;
  final String userId;
  const ProfilePage(
      {super.key, required this.userId, this.shouldFetchUser = true});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    if (widget.shouldFetchUser) {
      // Fetch the user data if the flag is true
      context.read<UserBloc>().add(FetchUserById(widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Single BlocBuilder for UserBloc
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoading) {
                  return const SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                } else if (userState is UserLoaded) {
                  final user = userState.user;
                  return SliverAppBar(
                    expandedHeight: 200,
                    collapsedHeight: 0,
                    toolbarHeight: 0,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: user.cover,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 3,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Container(
                            height: 170,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  offset: const Offset(0, -140),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(64),
                                      border: Border.all(
                                        color: AppColors.background,
                                        width: 4,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.background,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.profilePic),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.backgroundDarker,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.background,
                                          radius: 18,
                                          child: SvgPicture.asset(
                                            'assets/svg/edit_fill.svg',
                                            height: 20,
                                            width: 20,
                                            color: AppColors.primary
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.backgroundDarker,
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.background,
                                          radius: 18,
                                          child: SvgPicture.asset(
                                            'assets/svg/message_2_fill.svg',
                                            height: 20,
                                            width: 20,
                                            color: AppColors.primary
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      RoundedRectangleButton(
                                        elevation: 0,
                                        text: 'Follow',
                                        onPressed: () {},
                                        backgroundColor: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (userState is UserError) {
                  return SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: Center(
                      child: Text(userState.message),
                    ),
                  );
                } else {
                  return const SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: Center(
                      child: Text('No user data available.'),
                    ),
                  );
                }
              },
            ),
            // Single BlocBuilder for UserBloc and PostBloc
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded) {
                  final user = userState.user;
                  return BlocBuilder<PostBloc, PostState>(
                    builder: (context, postState) {
                      if (postState is PostLoading) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      } else if (postState is PostsLoaded) {
                        return SliverList(
                          delegate: SliverChildListDelegate([
                            // User Info Section
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.background,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.platinum,
                                          width: 0.7,
                                        ),
                                      ),
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight:
                                            MediaQuery.sizeOf(context).height /
                                                5,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.username,
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '@${user.handle}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  "well this time I break, I will never live, another day",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w100),
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(height: 16),
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '136',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'Followers',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '231',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'Following',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '24',
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'Posts',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Posts Section
                            ...postState.posts.map((post) {
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
                            }),
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
}
