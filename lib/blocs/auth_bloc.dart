import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mozaik/events/auth_event.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/google_sign_in_service.dart';
import 'package:mozaik/states/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignInService _googleSignInService;
  final UserService _userService;
  final SharedPreferences _prefs;

  AuthBloc({
    required UserService userService,
    required GoogleSignInService googleSignInService,
    required SharedPreferences prefs,
  })  : _userService = userService,
        _googleSignInService = googleSignInService,
        _prefs = prefs,
        super(AuthInitial()) {
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
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

      final userJson = await _userService.fetchUserById(userId, token: token);
      final user = User.fromJson(userJson);

      await _persistAuthData(token, user);

      emit(Authenticated(token: token, user: user));
    } on http.ClientException catch (e) {
      emit(AuthError('Network error: ${e.message}'));
    } on FormatException catch (e) {
      emit(AuthError(e.message));
    } catch (e, stackTrace) {
      _logError('Google sign-in', e, stackTrace);
      emit(AuthError('Sign-in failed: ${e.toString()}'));
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

      final userJson = await _userService.fetchUserById(userId, token: token);
      final user = User.fromJson(userJson);

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
    print('$operation error: $error');
    if (stackTrace != null) print(stackTrace);
  }
}
