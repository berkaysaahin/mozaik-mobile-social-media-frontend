import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/text_post.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/services/post_service.dart';

class FollowingPage extends StatefulWidget {
  final ScrollController scrollController;
  const FollowingPage({super.key, required this.scrollController});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<Post> posts = [];
  bool isLoading = true;
  String? errorMessage;

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
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load posts: $e';
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
        else if (errorMessage != null)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if (posts.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text('No posts available.'),
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
