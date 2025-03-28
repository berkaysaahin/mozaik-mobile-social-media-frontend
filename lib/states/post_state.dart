import 'package:mozaik/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostCreated extends PostState {
  final Post post;

  PostCreated(this.post);
}

class PostsCombinedState extends PostState {
  final List<Post> generalPosts;
  final List<Post> userPosts;
  final bool showingUserPosts;
  final Set<int> loadingPostIds;
  final Set<int> loadedPostIds;

  PostsCombinedState({
    required this.generalPosts,
    required this.userPosts,
    required this.showingUserPosts,
    this.loadingPostIds = const {},
    this.loadedPostIds = const {},
  });

  PostsCombinedState copyWith({
    List<Post>? generalPosts,
    List<Post>? userPosts,
    bool? showingUserPosts,
    Set<int>? loadingPostIds,
    Set<int>? loadedPostIds,
  }) {
    return PostsCombinedState(
      generalPosts: generalPosts ?? this.generalPosts,
      userPosts: userPosts ?? this.userPosts,
      showingUserPosts: showingUserPosts ?? this.showingUserPosts,
      loadingPostIds: loadingPostIds ?? this.loadingPostIds,
      loadedPostIds: loadedPostIds ?? this.loadedPostIds,
    );
  }
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostDeleted extends PostState {}
