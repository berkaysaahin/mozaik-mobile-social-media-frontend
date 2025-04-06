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
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615",
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Berkay Şahin ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'Feb 8',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
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
