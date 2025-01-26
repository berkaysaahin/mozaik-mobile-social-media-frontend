import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/message_bubble.dart';

class DirectMessagePage extends StatelessWidget {
  const DirectMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        rightIcon: const Icon(FluentIcons.more_vertical_24_regular),
        onLeftIconTap: () {
          Navigator.pop(context);
        },
        onRightIconTap: () {},
        title: "Eve",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBubble(
                      text: "Hi there!",
                      isSent: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBubble(
                      text: "Hello! How are you?",
                      isSent: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBubble(
                      text: "I'm good, thanks. You?",
                      isSent: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBubble(
                      text: "Doing great!",
                      isSent: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray, // Custom hint text color
                        fontSize: 16, // Hint text font size
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ), // Padding inside the TextField
                      // Background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none, // Removes default border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppColors.ashBlue, // Border color when focused
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors
                              .grey[400]!, // Border color when not focused
                        ),
                      ),
                      suffixIcon: const Icon(
                        FluentIcons
                            .emoji_24_regular, // Icon at the right end of the TextField
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black, // Input text color
                      fontSize: 16, // Input text font size
                    ),
                    cursorColor: AppColors.ashBlue, // Cursor color
                    maxLines: 1, // Single-line input
                    onSubmitted: (value) {
                      // Handle message submission
                      print("Message submitted: $value");
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  elevation: 0,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.ashBlue,
                  onPressed: () {
                    // Handle message sending
                  },
                  child: const Icon(FluentIcons.arrow_right_24_filled),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
