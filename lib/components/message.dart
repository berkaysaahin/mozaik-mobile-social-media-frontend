import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/pages/direct_message.dart';

class MessageComponent extends StatelessWidget {
  final String conversationId;
  final String recipientName;
  final String recipientHandle;
  final String recipientAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final String currentUserId;
  const MessageComponent(
      {super.key,
      required this.conversationId,
      required this.recipientName,
      required this.recipientHandle,
      required this.recipientAvatar,
      required this.lastMessage,
      required this.currentUserId,
      required this.lastMessageTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DirectMessagePage(
            conversationId: conversationId,
            recipientName: recipientName,
            recipientAvatar: recipientAvatar,
            currentUserId: currentUserId,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.backgroundDark
                  : AppColors.background,
              width: 0.1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: recipientAvatar,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            recipientName,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '@$recipientHandle',
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                          ),
                        ],
                      ),
                      Text(
                        lastMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    lastMessageTime,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
