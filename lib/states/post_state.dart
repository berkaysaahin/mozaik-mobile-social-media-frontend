import 'package:mozaik/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreated extends PostState {
  final Post post;

  PostCreated(this.post);
}

class PostsLoaded extends PostState {
  final List<Post> posts;

  PostsLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostDeleted extends PostState {}
