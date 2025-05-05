import 'package:mozaik/models/user_model.dart';

abstract class ProfileEvent {}

class FetchProfileById extends ProfileEvent {
  final String userId;

  FetchProfileById(this.userId);
}
class SetProfileUser extends ProfileEvent {
  final User user;
  SetProfileUser(this.user);
}
