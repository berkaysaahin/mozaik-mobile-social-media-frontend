abstract class PostEvent {}

class CreatePostEvent extends PostEvent {
  final String userId;
  final String content;
  final String? spotifyTrackId;
  final String visibility;
  final String? imageUrl;

  CreatePostEvent({
    required this.userId,
    required this.content,
    this.spotifyTrackId,
    required this.visibility,
    this.imageUrl,
  });
}
