import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent {
  final String? currentUserId;

  const FetchPosts({this.currentUserId});
}

class FetchPostsByUser extends PostEvent {
  final String id;

  const FetchPostsByUser(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearUserPosts extends PostEvent {}

class StartPostLoading extends PostEvent {
  final int postId;
  const StartPostLoading(this.postId);
}

class StopPostLoading extends PostEvent {
  final int postId;
  const StopPostLoading(this.postId);
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
  final String? imageUrl;

  const DeletePost(this.postId, {this.imageUrl});

  @override
  List<Object?> get props => [postId];
}
