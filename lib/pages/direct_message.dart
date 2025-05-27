import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/message_bloc.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/message_bubble.dart';
import 'package:mozaik/models/message_model.dart';
import 'package:mozaik/states/message_state.dart';

import '../events/message_event.dart';

class DirectMessagePage extends StatefulWidget {
  final String conversationId;
  final String recipientName;
  final String recipientAvatar;
  final String currentUserId;

  const DirectMessagePage({
    super.key,
    required this.conversationId,
    required this.recipientName,
    required this.recipientAvatar,
    required this.currentUserId,
  });

  @override
  State<DirectMessagePage> createState() => _DirectMessagePageState();
}

class _DirectMessagePageState extends State<DirectMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isEmojiVisible = false;

  @override
  void initState() {
    super.initState();

    context.read<MessageBloc>().add(LoadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  void _toggleEmojiKeyboard() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isEmojiVisible = !_isEmojiVisible;
    });
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<MessageBloc>().add(
            SendMessage(widget.conversationId, content),
          );
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  List<_MessageListItem> _flattenMessages(List<Message> messages) {
    final List<_MessageListItem> result = [];
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat todayFormatter = DateFormat('h:mm a');

    final grouped = <String, List<Message>>{};

    for (final msg in messages.reversed) {
      final dateKey = dateFormatter.format(msg.sentAt);
      grouped.putIfAbsent(dateKey, () => []).add(msg);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final otherDayFormatter = DateFormat('MMM d, yyyy');

    grouped.forEach((dateKey, msgs) {
      final parsedDate = DateTime.parse(dateKey);
      final dateOnly =
          DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      String label;
      if (dateOnly == today) {
        label = "Today";
      } else if (dateOnly == yesterday) {
        label = "Yesterday";
      } else {
        label = otherDayFormatter.format(parsedDate);
      }
      result.add(_MessageListItem.date(label));
      for (final msg in msgs) {
        result.add(_MessageListItem.message(msg));
      }
    });

    return result;
  }

  Widget _buildMessageList(List<Message> messages) {
    final items = _flattenMessages(messages);
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.dateHeader != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]
                      : Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.dateHeader!,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white54,
                      ),
                ),
              ),
            ),
          );
        } else if (item.message != null) {
          final message = item.message!;
          return Align(
            alignment: message.senderId == widget.currentUserId
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: MessageBubble(
              text: message.content,
              isSent: message.senderId == widget.currentUserId,
              timestamp: DateFormat('h:mm a').format(message.sentAt),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      appBar: CustomAppBar(
        leftIcon: const Icon(FluentIcons.arrow_left_24_regular),
        rightWidget: const Icon(FluentIcons.more_vertical_24_regular),
        onLeftIconTap: (BuildContext context) => Navigator.pop(context),
        onRightWidgetTap: (BuildContext context) {},
        customWidget: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(widget.recipientAvatar),
              ),
              const SizedBox(width: 8),
              Text(
                widget.recipientName,
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
            Expanded(
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoadSuccess) {
                    return _buildMessageList(state.messages);
                  } else if (state is MessageLoadFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is MessageOperationFailure) {
                    return _buildMessageList(state.messages);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
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
                          setState(() => _isEmojiVisible = false);
                        }
                      },
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Color.lerp(Colors.white, Colors.grey, 0.2)
                                : Color.lerp(Colors.black, Colors.white, 0.2),
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Color.lerp(Colors.white, Colors.grey, 0.2)
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
                          icon: const Icon(FluentIcons.emoji_24_regular),
                          onPressed: _toggleEmojiKeyboard,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    elevation: 0,
                    mini: true,
                    focusElevation: 0,
                    shape: const CircleBorder(),
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: _sendMessage,
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
                  onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
                  config: Config(
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      buttonColor: Theme.of(context).primaryColor,
                      buttonIconColor: AppColors.amanojaku,
                    ),
                    emojiViewConfig: EmojiViewConfig(
                      columns: 9,
                      emojiSizeMax: 28,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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

class _MessageListItem {
  final String? dateHeader;
  final Message? message;

  _MessageListItem.date(this.dateHeader) : message = null;
  _MessageListItem.message(this.message) : dateHeader = null;
}
