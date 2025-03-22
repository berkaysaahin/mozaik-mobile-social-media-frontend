abstract class UserEvent {}

class FetchUserById extends UserEvent {
  final String id;
  FetchUserById(this.id);
}
