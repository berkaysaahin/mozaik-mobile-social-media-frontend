abstract class ProfileEvent {}

class FetchProfileById extends ProfileEvent {
  final String userId;

  FetchProfileById(this.userId);
}
