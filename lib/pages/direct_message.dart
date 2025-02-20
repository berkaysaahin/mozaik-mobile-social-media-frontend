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
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        rightIcon: const Icon(FluentIcons.more_vertical_24_regular),
        onLeftIconTap: (BuildContext context) {
          Navigator.pop(context);
        },
        onRightIconTap: (BuildContext context) {},
        title: "Eve",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MessageBubble(
                    text:
                        "Hi there!theretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretheretherethere",
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
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppColors.platinum,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          FluentIcons.emoji_24_regular,
                        ),
                        onPressed: _toggleEmojiKeyboard,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  elevation: 0,
                  mini: true,
                  focusElevation: 0,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.amanojaku,
                  onPressed: () {},
                  child: const Icon(
                    FluentIcons.arrow_right_24_filled,
                    color: Colors.white,
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
                config: const Config(
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: AppColors.weeping,
                    buttonColor: AppColors.weeping,
                    buttonIconColor: AppColors.amanojaku,
                  ),
                  emojiViewConfig: EmojiViewConfig(
                    columns: 9,
                    emojiSizeMax: 28,
                    backgroundColor: AppColors.weeping,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: AppColors.amanojaku,
                    iconColor: Colors.white,
                    iconColorSelected: AppColors.charcoal,
                    indicatorColor: AppColors.charcoal,
                    dividerColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
