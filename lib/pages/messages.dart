import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/message.dart';
import 'package:mozaik/components/search_bar.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomSearchBar(
                  hintText: "Search in messages",
                  height: 52,
                  borderRadius: 12,
                ),
              ),
              Container(
                color: AppColors.background,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
                    MessageComponent(),
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
