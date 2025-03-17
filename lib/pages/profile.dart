import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:mozaik/blocs/user_bloc.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/user_service.dart';
import 'package:mozaik/states/post_state.dart';
import 'package:mozaik/states/user_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user = User(
    id: "0",
    username: 'Loading...',
    handle: 'loading',
    email: 'loading@example.com',
    profilePic: '',
    cover: '',
    createdAt: DateTime(2, 2, 2, 2),
  );

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<UserBloc>().add(FetchUserByHandle('berkaysahin'));
      context.read<PostBloc>().add(FetchPostsByUser('berkaysahin'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
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
                          Image.network(
                            user.cover,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
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
                                          NetworkImage(user.profilePic),
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
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  color: AppColors.primary,
                                                  size: 20,
                                                  Icons.edit)),
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
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  color: AppColors.primary,
                                                  size: 20,
                                                  Icons.email)),
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
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded) {
                  user = userState.user;
                  return SliverList(
                    delegate: SliverChildListDelegate([
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
                                      MediaQuery.sizeOf(context).height / 5,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                fontWeight: FontWeight.w300),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          const Text(
                                            "well this time I break, I will never live, another day",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w100),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Followers',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Following',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Posts',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300),
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
                    ]),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                } else if (state is PostsLoaded) {
                  return SliverList(
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
                                music: post.music,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        );
                      },
                      childCount: state.posts.length,
                    ),
                  );
                } else if (state is PostError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(state.message),
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
            ),
          ],
        ),
      ),
    );
  }
}
