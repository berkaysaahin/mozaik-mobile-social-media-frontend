import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/text_post.dart';

class FollowingPage extends StatelessWidget {
  final ScrollController scrollController;
  const FollowingPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: const Color.fromARGB(41, 229, 230, 228),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                    SizedBox(height: 12),
                    TextPost(),
                  ],
                ),
              ),
            ],
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
