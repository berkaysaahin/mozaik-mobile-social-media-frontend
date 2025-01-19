import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/text_post.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: const Color.fromARGB(41, 229, 230, 228),
                child: Column(
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
