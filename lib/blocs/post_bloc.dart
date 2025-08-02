import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/services/post_service.dart';
import 'package:mozaik/states/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final List<Post> _generalPostsCache = [];
  final List<Post> _currentUserPostsCache = [];
  final List<Post> _viewedUserPostsCache = [];
  final Set<int> _loadedPostIds = {};
  final Set<int> _loadingPostIds = {};
  final String? currentUserId;

  PostBloc({this.currentUserId}) : super(PostInitial()) {
    on<CreatePostEvent>(_onCreatePostEvent);
    on<FetchPosts>(_onFetchPosts);
    on<FetchPostsByUser>(_onFetchPostsByUser);
    on<DeletePost>(_onDeletePost);
    on<ClearUserPosts>(_onClearUserPosts);
    on<StartPostLoading>(_onStartPostLoading);
    on<StopPostLoading>(_onStopPostLoading);
    on<UpdatePosts>(_onUpdatePosts);
  }
  void _onClearUserPosts(ClearUserPosts event, Emitter<PostState> emit) {
    _viewedUserPostsCache.clear();
    emit(PostsCombinedState(
      generalPosts: _generalPostsCache,
      currentUserPosts: _currentUserPostsCache,
      viewedUserPosts: [],
      viewType: PostViewType.general,
      loadingPostIds: _loadingPostIds,
      loadedPostIds: _loadedPostIds,
    ));
  }

  Future<void> _onFetchPostsByUser(
      FetchPostsByUser event, Emitter<PostState> emit) async {
    if (_viewedUserPostsCache.isNotEmpty &&
        _viewedUserPostsCache[0].userId == event.id) {
      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        currentUserPosts: _currentUserPostsCache,
        viewedUserPosts: _viewedUserPostsCache,
        viewType: PostViewType.viewedUser,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } else {
      emit(PostLoading());
    }

    try {
      final posts = await PostService.fetchPostsByUser(event.id);
      _viewedUserPostsCache
        ..clear()
        ..addAll(posts);

      _loadedPostIds.addAll(posts.map((post) => post.id));

      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        currentUserPosts: _currentUserPostsCache,
        viewedUserPosts: _viewedUserPostsCache,
        viewType: PostViewType.viewedUser,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } catch (e) {
      emit(PostError('Failed to load posts: $e'));
    }
  }

  void _onStartPostLoading(StartPostLoading event, Emitter<PostState> emit) {
    _loadingPostIds.add(event.postId);
    _loadedPostIds.remove(event.postId);

    if (state is PostsCombinedState) {
      emit((state as PostsCombinedState).copyWith(
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    }
  }

  void _onStopPostLoading(StopPostLoading event, Emitter<PostState> emit) {
    _loadingPostIds.remove(event.postId);
    _loadedPostIds.add(event.postId);

    if (state is PostsCombinedState) {
      emit((state as PostsCombinedState).copyWith(
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    }
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    if (_generalPostsCache.isNotEmpty) {
      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        currentUserPosts: _currentUserPostsCache,
        viewedUserPosts: _viewedUserPostsCache,
        viewType: PostViewType.general,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } else {
      emit(PostLoading());
    }

    try {
      final posts = await PostService.fetchPosts(currentUserId: currentUserId);
      _generalPostsCache
        ..clear()
        ..addAll(posts);

      if (currentUserId != null) {
        _currentUserPostsCache
          ..clear()
          ..addAll(
              posts.where((post) => post.userId == currentUserId).toList());
      }

      _loadedPostIds.addAll(posts.map((post) => post.id));

      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        currentUserPosts: _currentUserPostsCache,
        viewedUserPosts: _viewedUserPostsCache,
        viewType: PostViewType.general,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } catch (e) {
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

  Future<void> _onCreatePostEvent(
      CreatePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());

    try {
      final newPost = await PostService.createPost(
        userId: event.userId,
        content: event.content,
        spotifyTrackId: event.spotifyTrackId,
        visibility: event.visibility,
        imageUrl: event.imageUrl,
      );

      _generalPostsCache.insert(0, newPost);
      if (event.userId == currentUserId) {
        _currentUserPostsCache.insert(0, newPost);
      }

      emit(PostCreated(newPost));
      add(FetchPosts());
    } catch (e) {
      emit(PostError('Failed to create post: $e'));
    }
  }

  Future<void> _onUpdatePosts(
      UpdatePosts event, Emitter<PostState> emit) async {
    final currentState = state;
    if (currentState is PostsCombinedState) {
      emit(currentState.copyWith(
        generalPosts: event.updatedPosts,
        currentUserPosts: event.updatedPosts
            .where((post) => post.userId == currentUserId)
            .toList(),
        viewedUserPosts: currentState.viewedUserPosts,
      ));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(event.imageUrl!);
          await ref.delete();
        } catch (e) {
          emit(PostError('Failed to delete image: $e'));
        }
      }

      await PostService.deletePost(event.postId);

      _generalPostsCache.removeWhere((post) => post.id == event.postId);
      _currentUserPostsCache.removeWhere((post) => post.id == event.postId);
      _viewedUserPostsCache.removeWhere((post) => post.id == event.postId);

      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        currentUserPosts: _currentUserPostsCache,
        viewedUserPosts: _viewedUserPostsCache,
        viewType: state is PostsCombinedState
            ? (state as PostsCombinedState).viewType
            : PostViewType.general,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } catch (e) {
      emit(PostError('Failed to delete post: $e'));
    }
  }
}
