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
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserLoading) {
                    return SliverAppBar(
                      expandedHeight: 200,
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
                      expandedHeight: 210,
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
                            CachedNetworkImage(
                              imageUrl: user.cover,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 3,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  AppRoundedButton(
                                      size: 36,
                                      onTap: () {
                                        context
                                            .read<PostBloc>()
                                            .add(ClearUserPosts());

                                        context
                                            .read<PostBloc>()
                                            .add(FetchPosts());

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      iconColor: Theme.of(context)
                                          .dialogBackgroundColor,
                                      iconData:
                                          FluentIcons.arrow_left_12_regular,
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            IgnorePointer(
                              child: Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      offset: const Offset(0, -140),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? AppColors.background
                                                    : AppColors.backgroundDark,
                                            width: 4,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? AppColors.background
                                                  : AppColors.backgroundDark,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  user.profilePic),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
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
                                          fontWeight: FontWeight.bold,
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
                                          ),
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
            ];
          },
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserLoaded) {
                final user = userState.user;
                return BlocBuilder<PostBloc, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 3,
                        ),
                      );
                    } else if (postState is PostsCombinedState) {
                      final posts = postState.userPosts.isNotEmpty
                          ? postState.userPosts
                          : postState.generalPosts;
                      return ListView(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.background
                                  : AppColors.backgroundDark,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? AppColors.backgroundDark
                                            : AppColors.background,
                                        width: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.sizeOf(context).height / 6,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
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
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),
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
                                              const SizedBox(height: 8),
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '8',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Followers',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '12',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Following',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '3',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    'Posts',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
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
                          ...posts.map((post) {
                            return Container(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.background
                                  : AppColors.backgroundDark,
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
                                    imageUrl: post.imageUrl,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    } else if (postState is PostError) {
                      return Center(
                        child: Text(postState.message),
                      );
                    } else {
                      return const Center(
                        child: Text('No posts available.'),
                      );
                    }
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
