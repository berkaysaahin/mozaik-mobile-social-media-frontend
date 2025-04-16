import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/message_bubble.dart';

class DirectMessagePage extends StatefulWidget {
  const DirectMessagePage({super.key});

  @override
  State<DirectMessagePage> createState() => _DirectMessagePageState();
}

class _DirectMessagePageState extends State<DirectMessagePage> {
  final TextEditingController _messageController = TextEditingController();

  void _onEmojiSelected(Emoji emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji.emoji,
    );
    _messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + emoji.emoji.length,
      ),
    );
  }

  bool _isEmojiVisible = false;

  void _toggleEmojiKeyboard() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        rightWidget: const Icon(FluentIcons.more_vertical_24_regular),
        onLeftIconTap: (BuildContext context) {
          Navigator.pop(context);
        },
        onRightWidgetTap: (BuildContext context) {},
        customWidget:  Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                    "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615"),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Someone",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.background
            : AppColors.backgroundDark,
        child: Column(
          children: [
             Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Today",
                style: Theme.of(context).textTheme.labelMedium,

              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBubble(
                      text: "Hi lorem ipsum",
                      isSent: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBubble(
                      text: "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
                      isSent: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MessageBubble(
                      text: "lorem ipsum lorem ipsum lorem ipsum",
                      isSent: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MessageBubble(
                      text: "lorem ipsum",
                      isSent: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (_isEmojiVisible) {
                          setState(() {
                            _isEmojiVisible = false;
                          });
                        }
                      },
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).brightness ==
                                Brightness.light
                            ? Color.lerp(
                                Colors.white, Colors.grey, 0.2) // Light mode
                            : Color.lerp(Colors.black, Colors.white, 0.2),
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Color.lerp(
                                  Colors.white, Colors.grey, 0.2) // Light mode
                              : Color.lerp(Colors.black, Colors.white, 0.2),
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            FluentIcons.emoji_24_regular,
                          ),
                          onPressed: _toggleEmojiKeyboard,
                        ),
                      ),
                      style:  Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    elevation: 0,
                    mini: true,
                    focusElevation: 0,
                    shape: const CircleBorder(),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Icon(
                      FluentIcons.arrow_right_24_filled,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.background
                          : AppColors.backgroundDark,
                    ),
                  ),
                ],
              ),
            ),
            if (_isEmojiVisible)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  onBackspacePressed: () {
                    final text = _messageController.text;
                    if (text.isNotEmpty) {
                      _messageController.value = TextEditingValue(
                        text: text.characters.skipLast(1).toString(),
                        selection: TextSelection.collapsed(
                          offset: text.characters.skipLast(1).length,
                        ),
                      );
                    }
                  },
                  onEmojiSelected: (category, emoji) {
                    _onEmojiSelected(emoji);
                  },
                  config: Config(
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      buttonColor: Theme.of(context).primaryColor,
                      buttonIconColor: AppColors.amanojaku,
                    ),
                    emojiViewConfig: EmojiViewConfig(
                      columns: 9,
                      emojiSizeMax: 28,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: AppColors.amanojaku,
                      iconColor: Colors.white,
                      iconColorSelected: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                      dividerColor: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
