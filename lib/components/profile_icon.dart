import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/states/auth_state.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.ashBlue,
            child: ClipOval(
              child: Image.network(
                authState.user.profilePic,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else if (authState is Unauthenticated) {
          return const Icon(Icons.error);
        } else {
          return Transform.scale(
            scale: 0.5,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2,
            ),
          );
        }
      },
    );
  }
}
