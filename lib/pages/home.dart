import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/services/post_service.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  const HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final fetchedPosts = await PostService.fetchPosts();
      setState(() {
        posts = fetchedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load posts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: AppColors.platinum,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
