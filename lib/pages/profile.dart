import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/rounded_rectangle_button.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/post_service.dart';
import 'package:mozaik/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> posts = [];

  bool isLoading = true;

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
    fetchUserAndPosts();
  }

  Future<void> fetchUserAndPosts() async {
    try {
      final fetchedUser = await UserService.fetchUserByHandle('berkaysahin');

      final fetchedPosts = await PostService.fetchPostsByUser('berkaysahin');

      if (mounted) {
        setState(() {
          posts = fetchedPosts;
          user = fetchedUser;

          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user or posts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
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
                                backgroundImage: NetworkImage(user.profilePic),
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
                                            color: AppColors.charcoal,
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
                                            color: AppColors.charcoal,
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
            ),
            SliverList(
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
                            minHeight: MediaQuery.sizeOf(context).height / 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '231',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Followers',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '231',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Following',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '24',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Posts',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        "kono omoi o kitto kasarete sekai no naka",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          'Date of entry: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          '24.02.2016',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
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
            ),
            if (isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
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
        ),
      ),
    );
  }
}
