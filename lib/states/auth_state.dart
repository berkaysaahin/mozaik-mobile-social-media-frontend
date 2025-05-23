import 'package:equatable/equatable.dart';
import 'package:mozaik/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final String token;
  final User user;

  const Authenticated({required this.token, required this.user});

  @override
  List<Object> get props => [token, user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}