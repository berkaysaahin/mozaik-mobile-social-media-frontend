import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
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
    password: "0",
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            collapsedHeight: 10,
            toolbarHeight: 10,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Image.network(
                    user.cover,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 170,
                  ),
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.1), // Slight shadow color
                          offset: Offset(
                              0, -140), // Shadow from the top (vertical offset)
                          blurRadius: 6, // Blur radius for the shadow
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(64),
                        border: Border.all(
                          color: const Color.fromARGB(136, 229, 230, 228),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.background,
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
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
                              padding: const EdgeInsets.all(16.0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Followers: ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Following: ',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
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
                    color: const Color.fromARGB(41, 229, 230, 228),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextPost(
                          username: post.username,
                          handle: post.handle,
                          content: post.content,
                          likes: post.likes,
                          retweets: post.retweets,
                          comments: post.comments,
                          timestamp: post.timestamp,
                          profilePic: post.profilePic,
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
    );
  }
}
