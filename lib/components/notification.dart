import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CustomNotification({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.platinum,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.battleshipGray,
            size: 28,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title - $message',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
