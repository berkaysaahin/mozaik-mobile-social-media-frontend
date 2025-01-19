import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.platinum,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.platinum,
                child: const Icon(
                  Icons.person,
                  color: AppColors.charcoal,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Berkay Şahin',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '@berkaysahin',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '6h',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 130,
                    width: double.maxFinite,
                    child: Text(
                      'Im actually so happy that mmj got this cover bc ive been wanting  for a long time for mmj to cover a more badass/vbs-like song, and to break the standards of a mmj song, which is usually cutesy and poppy and wtv',
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
