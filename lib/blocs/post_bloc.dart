import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/models/post_model.dart';
import 'package:mozaik/services/post_service.dart';
import 'package:mozaik/states/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  List<Post> _generalPostsCache = [];
  final List<Post> _userPostsCache = [];
  final Set<int> _loadedPostIds = {};
  final Set<int> _loadingPostIds = {};

  PostBloc() : super(PostInitial()) {
    on<CreatePostEvent>(_onCreatePostEvent);
    on<FetchPosts>(_onFetchPosts);
    on<FetchPostsByUser>(_onFetchPostsByUser);
    on<DeletePost>(_onDeletePost);
    on<ClearUserPosts>(_onClearUserPosts);
    on<StartPostLoading>(_onStartPostLoading);
    on<StopPostLoading>(_onStopPostLoading);
  }
  void _onClearUserPosts(ClearUserPosts event, Emitter<PostState> emit) {
    _userPostsCache.clear();
    if (state is PostsCombinedState) {
      emit((state as PostsCombinedState).copyWith(
        userPosts: [],
        showingUserPosts: true,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } else {
      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        userPosts: [],
        showingUserPosts: true,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    }
  }

  Future<void> _onFetchPostsByUser(
      FetchPostsByUser event, Emitter<PostState> emit) async {
    if (_userPostsCache.isNotEmpty && _userPostsCache[0].userId == event.id) {
      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        userPosts: _userPostsCache,
        showingUserPosts: true,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } else {
      emit(PostLoading());
    }

    try {
      final posts = await PostService.fetchPostsByUser(event.id);
      _userPostsCache
        ..clear()
        ..addAll(posts);

      _loadedPostIds.addAll(posts.map((post) => post.id));

      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        userPosts: _userPostsCache,
        showingUserPosts: true,
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
        userPosts: _userPostsCache,
        showingUserPosts: false,
        loadingPostIds: _loadingPostIds,
        loadedPostIds: _loadedPostIds,
      ));
    } else {
      emit(PostLoading());
    }

    try {
      final posts = await PostService.fetchPosts();
      _generalPostsCache = posts;
      _loadedPostIds.addAll(posts.map((post) => post.id));

      emit(PostsCombinedState(
        generalPosts: _generalPostsCache,
        userPosts: _userPostsCache,
        showingUserPosts: false,
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
      emit(PostCreated(newPost));
      add(FetchPosts());
    } catch (e) {
      emit(PostError('Failed to create post: $e'));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      await PostService.deletePost(event.postId);
      final posts = await PostService.fetchPosts();

      _generalPostsCache = posts;
      if (_generalPostsCache.isNotEmpty) {
        emit(PostsCombinedState(
          generalPosts: _generalPostsCache,
          userPosts: _userPostsCache,
          showingUserPosts: false,
        ));
        return;
      }
    } catch (e) {
      emit(PostError('Failed to delete post: $e'));
    }
  }
}
