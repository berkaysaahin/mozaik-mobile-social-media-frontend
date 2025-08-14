import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mozaik/events/auth_event.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/auth_service.dart';
import 'package:mozaik/services/google_sign_in_service.dart';
import 'package:mozaik/states/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignInService _googleSignInService;
  final AuthService _authService;
  final UserService _userService;
  final SharedPreferences _prefs;

  AuthBloc({
    required AuthService authService,
    required UserService userService,
    required GoogleSignInService googleSignInService,
    required SharedPreferences prefs,
  })  : _userService = userService,
        _authService = authService,
        _googleSignInService = googleSignInService,
        _prefs = prefs,
        super(AuthInitial()) {
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<UserProfileUpdateRequested>(_onUpdateUserProfile);
  }

  Future<void> _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _authService.loginWithEmail(
        email: event.email,
        password: event.password,
      );

      final userId = _parseUserIdFromToken(token);
      if (userId == null) {
        throw const FormatException('Invalid token format - missing user ID');
      }

      final user = await _userService.fetchUserById(userId, token: token);

      await _persistAuthData(token, user);

      emit(Authenticated(token: token, user: user));
    } catch (e, stackTrace) {
      _logError('Email sign-in', e, stackTrace);
      emit(AuthError('Email login failed: ${e.toString()}'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _googleSignInService.signInWithGoogle();
      if (token == null) {
        emit(const AuthError('Google sign-in failed'));
        return;
      }
      final userId = _parseUserIdFromToken(token);

      if (userId == null) {
        throw const FormatException('Invalid token format - missing user ID');
      }
      final user = await _userService.fetchUserById(userId, token: token);

      await _persistAuthData(token, user);

      emit(Authenticated(token: token, user: user));
    } catch (e, stackTrace) {
      _logError('Google sign-in', e, stackTrace);
      emit(AuthError('Sign-in failed: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UserProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (state is Authenticated) {
        final currentState = state as Authenticated;
        emit(AuthLoading());

        final updatedUser = await _userService.updateUserProfile(
          userId: event.userId,
          token: currentState.token,
          profilePic: event.profilePic,
          cover: event.cover,
          username: event.username,
          bio: event.bio,
          handle: event.handle,
          email: event.email,
        );

        await _persistAuthData(currentState.token, updatedUser);
        emit(Authenticated(token: currentState.token, user: updatedUser));
      }
    } catch (e, stackTrace) {
      _logError('Profile update', e, stackTrace);
      emit(AuthError('Failed to update profile: ${e.toString()}'));
      if (state is Authenticated) {
        emit(state);
      }
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = _prefs.getString('auth_token');
      if (token == null) {
        emit(Unauthenticated());
        return;
      }

      final userId = _parseUserIdFromToken(token);
      if (userId == null) {
        await _clearAuthData();
        emit(Unauthenticated());
        return;
      }

      final user = await _userService.fetchUserById(userId, token: token);

      emit(Authenticated(token: token, user: user));
    } catch (e, stackTrace) {
      _logError('Auth status check', e, stackTrace);
      await _clearAuthData();
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _googleSignInService.signOut();

      await _clearAuthData();

      emit(Unauthenticated());
    } catch (e, stackTrace) {
      _logError('Sign-out', e, stackTrace);
      emit(AuthError('Sign-out failed: ${e.toString()}'));
    }
  }

  String? _parseUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      return payload['userId']?.toString();
    } catch (e) {
      _logError('Token parsing', e, null);
      return null;
    }
  }

  Future<void> _persistAuthData(String token, User user) async {
    await _prefs.setString('auth_token', token);
    await _prefs.setString('user_data', json.encode(user.toJson()));
  }

  Future<void> _clearAuthData() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_data');
  }

  void _logError(String operation, Object error, StackTrace? stackTrace) {
    log('$operation error: $error');
  }
}
