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
  final List<Post> currentUserPosts;
  final List<Post> viewedUserPosts;
  final PostViewType viewType;
  final Set<int> loadingPostIds;
  final Set<int> loadedPostIds;

  List<Post> get visiblePosts {
    switch (viewType) {
      case PostViewType.general:
        return generalPosts;
      case PostViewType.currentUser:
        return currentUserPosts;
      case PostViewType.viewedUser:
        return viewedUserPosts;
    }
  }

  PostsCombinedState({
    required this.generalPosts,
    required this.currentUserPosts,
    required this.viewedUserPosts,
    required this.viewType,
    this.loadingPostIds = const {},
    this.loadedPostIds = const {},
  });
  PostsCombinedState copyWith({
    List<Post>? generalPosts,
    List<Post>? currentUserPosts,
    List<Post>? viewedUserPosts,
    PostViewType? viewType,
    Set<int>? loadingPostIds,
    Set<int>? loadedPostIds,
  }) {
    return PostsCombinedState(
      generalPosts: generalPosts ?? this.generalPosts,
      currentUserPosts: currentUserPosts ?? this.currentUserPosts,
      viewedUserPosts: viewedUserPosts ?? this.viewedUserPosts,
      viewType: viewType ?? this.viewType,
      loadingPostIds: loadingPostIds ?? this.loadingPostIds,
      loadedPostIds: loadedPostIds ?? this.loadedPostIds,
    );
  }
}

enum PostViewType { general, currentUser, viewedUser }

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostDeleted extends PostState {}
