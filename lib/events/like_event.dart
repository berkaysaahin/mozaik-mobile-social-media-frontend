abstract class LikeEvent {}

class LikePost extends LikeEvent {
  final int postId;
  final String userId;

  LikePost(this.postId, this.userId);
}

class UnlikePost extends LikeEvent {
  final int postId;
  final String userId;

  UnlikePost(this.postId, this.userId);
}
