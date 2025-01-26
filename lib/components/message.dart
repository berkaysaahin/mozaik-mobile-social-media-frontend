import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';

class MessageComponent extends StatelessWidget {
  const MessageComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/directMessage'),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.platinum,
              width: 0.3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                    "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615"),
              ),
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Eve',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '@evemusic',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ],
                    ),
                    Text(
                      "You've been hoping to get something dramatic out of this storyline.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
