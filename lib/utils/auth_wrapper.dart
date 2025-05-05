import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/main.dart';
import 'package:mozaik/pages/login.dart';
import 'package:mozaik/states/auth_state.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MyHomePage();
        } else if (state is Unauthenticated) {
          return const LoginPage();
        } else if (state is AuthError) {
          return Center(child: Text(state.message));
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}