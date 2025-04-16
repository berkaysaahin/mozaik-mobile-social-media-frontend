import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  final Color? color;

  const PostButton({
    super.key,
    required this.icon,
    required this.count,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InkWell(
        child: SizedBox(
          width: 48,
          height: 48,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color ?? Colors.grey),
              const SizedBox(width: 6),
              if (count > 0)
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
