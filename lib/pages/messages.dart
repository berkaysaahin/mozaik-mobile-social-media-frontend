import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/message.dart';

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
              Container(
                color: AppColors.background,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
                    MessageComponent(),
                    SizedBox(height: 12),
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
