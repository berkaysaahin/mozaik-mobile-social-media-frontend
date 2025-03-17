abstract class UserEvent {}

class FetchUserByHandle extends UserEvent {
  final String handle;
  FetchUserByHandle(this.handle);
}
