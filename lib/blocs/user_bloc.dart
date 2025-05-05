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
      final userJson = await userService.fetchPublicUserById(event.id);

      final user = User.fromJson(userJson);
      emit(UserLoaded(user));
    } catch (e, stackTrace) {
      print('User fetch error: $e\n$stackTrace');
      emit(UserError('Failed to load user: ${e.toString()}'));
    }
  }
}
