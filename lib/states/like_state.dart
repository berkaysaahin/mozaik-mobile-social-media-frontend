abstract class LikeState {}

class LikeInitial extends LikeState {}

class LikeUpdated extends LikeState {
  final int postId;
  final bool hasLiked;
  final int likeCount;

  LikeUpdated(this.postId, this.hasLiked, this.likeCount);
}

class LikeError extends LikeState {
  final String message;
  LikeError(this.message);
}
