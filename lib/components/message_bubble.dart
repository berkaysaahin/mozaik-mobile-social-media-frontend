import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;

  const MessageBubble({required this.text, required this.isSent, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        color: isSent ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isSent ? 16 : 0),
          bottomRight: Radius.circular(isSent ? 0 : 16),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSent ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }
}
