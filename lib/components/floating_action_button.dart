import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/post_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:mozaik/events/post_event.dart';

class MyFloatingActionButton extends StatefulWidget {
  final bool isVisible;
  final int selectedIndex;
  final ValueNotifier<bool> isTabBarVisible;

  const MyFloatingActionButton({
    super.key,
    required this.isVisible,
    required this.selectedIndex,
    required this.isTabBarVisible,
  });

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isTabBarVisible,
      builder: (context, isVisible, child) {
        return Visibility(
          visible: isVisible && widget.selectedIndex == 0,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            ),
            elevation: 0,
            backgroundColor: AppColors.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/newPost');
              if (context.mounted && result == true) {
                context.read<PostBloc>().add(FetchPosts());
              }
            },
            child: const Icon(
              FluentIcons.add_24_filled,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
