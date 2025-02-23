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
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.platinum,
              width: 0.3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      "https://static.wikia.nocookie.net/projectsekai/images/f/ff/Dramaturgy_Game_Cover.png/revision/latest?cb=20201227073615"),
                ),
                const SizedBox(
                  width: 4,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Eve',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
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
                                color: AppColors.amanojaku,
                                fontWeight: FontWeight.w300),
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
                const Center(
                  child: Text(
                    'feb 20',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: AppColors.amanojaku),
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
