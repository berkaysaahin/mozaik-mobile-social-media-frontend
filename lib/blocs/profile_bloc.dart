import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/profile_event.dart';
import 'package:mozaik/services/user_service.dart';
import 'package:mozaik/states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileById>(_onFetchProfileById);
  }

  Future<void> _onFetchProfileById(
    FetchProfileById event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await UserService.fetchUserById(event.userId);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Failed to fetch profile user: $e'));
    }
  }
}
