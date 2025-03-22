import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent {}

class FetchPostsByUser extends PostEvent {
  final String handle;

  const FetchPostsByUser(this.handle);

  @override
  List<Object?> get props => [handle];
}

class CreatePostEvent extends PostEvent {
  final String userId;
  final String content;
  final String? spotifyTrackId;
  final String visibility;
  final String? imageUrl;

  const CreatePostEvent({
    required this.userId,
    required this.content,
    this.spotifyTrackId,
    required this.visibility,
    this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [userId, content, spotifyTrackId, visibility, imageUrl];
}

class DeletePost extends PostEvent {
  final int postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}
