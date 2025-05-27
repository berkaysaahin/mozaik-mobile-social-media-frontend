import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final String timestamp;

  const MessageBubble({
    required this.text,
    required this.isSent,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSent
              ? AppColors.itCantGetWorse
              : Theme.of(context).brightness == Brightness.light
                  ? Color.lerp(Colors.white, Colors.grey, 0.2)
                  : Color.lerp(Colors.black, Colors.white, 0.2),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSent ? 16 : 0),
            bottomRight: Radius.circular(isSent ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        isSent ? Colors.white : Theme.of(context).primaryColor,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "15:25",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSent ? Colors.white : Colors.grey[600],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
