import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/models/user_model.dart';
import 'package:mozaik/services/user_service.dart';
import 'package:mozaik/events/user_event.dart';
import 'package:mozaik/states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(UserInitial()) {
    on<FetchUserById>(_onFetchUserById);
  }

  Future<void> _onFetchUserById(
    FetchUserById event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userService.fetchPublicUserById(event.id);

      emit(UserLoaded(user));
    } catch (e, stackTrace) {
      log('User fetch error: $e', stackTrace: stackTrace);
      emit(UserError('Failed to load user: ${e.toString()}'));
    }
  }
}
