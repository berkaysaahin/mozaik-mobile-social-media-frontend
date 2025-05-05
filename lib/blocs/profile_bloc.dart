import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/blocs/auth_bloc.dart';
import 'package:mozaik/events/profile_event.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/user_service.dart';
import 'package:mozaik/states/profile_state.dart';
import 'package:mozaik/states/auth_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;
  final AuthBloc authBloc;
  User? _currentUser;

  ProfileBloc({required this.userService, required this.authBloc})
      : super(ProfileInitial()) {
    on<FetchProfileById>(_onFetchProfileById);
    on<SetProfileUser>(_onSetProfileUser);
  }

  Future<void> _onFetchProfileById(
      FetchProfileById event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final authState = authBloc.state;
      if (authState is! Authenticated) {
        throw Exception('User not authenticated');
      }

      final userJson = await userService.fetchUserById(
        event.userId,
        token: authState.token,
      );
      _currentUser = User.fromJson(userJson);
      emit(ProfileLoaded(_currentUser!));
    } catch (e, stackTrace) {
      print('Profile fetch error: $e\n$stackTrace');
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  void _onSetProfileUser(
      SetProfileUser event,
      Emitter<ProfileState> emit,
      ) {
    _currentUser = event.user;
    emit(ProfileLoaded(_currentUser!));
  }
}