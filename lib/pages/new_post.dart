import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String _visibility = 'Public';
  final TextEditingController _postController = TextEditingController();

  void _changeVisibility() {
    setState(() {
      _visibility = _visibility == 'Public' ? 'Private' : 'Public';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        onLeftIconTap: (context) {
          Navigator.pop(context);
        },
        title: "Post",
        rightWidget: TextButton(
          onPressed: () {
            final postText = _postController.text;
            if (postText.isNotEmpty) {
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please write something to post.')),
              );
            }
          },
          child: const Text(
            "Publish",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Berkay Sahin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _changeVisibility,
                      child: Row(
                        children: [
                          Text(
                            _visibility,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.teupeGray,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            FluentIcons.chevron_down_12_regular,
                            size: 16,
                            color: AppColors.teupeGray,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _postController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColors.teupeGray.withOpacity(0.6),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.teupeGray,
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: AppColors.platinum,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    FluentIcons.image_24_regular,
                    color: AppColors.teupeGray,
                  ),
                ),
                const SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    FluentIcons.camera_24_regular,
                    color: AppColors.teupeGray,
                  ),
                ),
                const SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    FluentIcons.music_note_1_20_regular,
                    color: AppColors.teupeGray,
                  ),
                ),
                const SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(
                    FluentIcons.emoji_24_regular,
                    color: AppColors.teupeGray,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: _changeVisibility,
                    child: Row(
                      children: [
                        Text(
                          _visibility,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.teupeGray,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          FluentIcons.chevron_down_12_regular,
                          size: 16,
                          color: AppColors.teupeGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
