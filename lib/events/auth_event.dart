import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
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