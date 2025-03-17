import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/services/user_service.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUserByHandle>(_onFetchUserByHandle);
  }

  Future<void> _onFetchUserByHandle(
      FetchUserByHandle event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await UserService.fetchUserByHandle(event.handle);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError('Failed to load user: $e'));
    }
  }
}
