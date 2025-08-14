import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailSignInRequested({required this.email, required this.password});
}


class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

class UserProfileUpdateRequested extends AuthEvent {
  final String userId;

  final String? profilePic;
  final String? cover;
  final String? username;
  final String? bio;
  final String? handle;
  final String? email;

  const UserProfileUpdateRequested({
    required this.userId,
    this.profilePic,
    this.cover,
    this.username,
    this.bio,
    this.handle,
    this.email,
  });

  @override
  List<Object> get props => [
        userId,
        email ?? '',
        handle ?? '',
        profilePic ?? '',
        cover ?? '',
        username ?? '',
        bio ?? '',
      ];
}
