import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/like_event.dart';
import 'package:mozaik/services/post_service.dart';
import 'package:mozaik/states/like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  LikeBloc() : super(LikeInitial()) {
    on<LikePost>(_onLikePost);
    on<UnlikePost>(_onUnlikePost);
  }

  Future<void> _onLikePost(LikePost event, Emitter<LikeState> emit) async {
    try {
      final result = await PostService.likePost(
          postId: event.postId, userId: event.userId);
      emit(LikeUpdated(event.postId, true, result));
    } catch (e) {
      emit(LikeError('Failed to like post: $e'));
    }
  }

  Future<void> _onUnlikePost(UnlikePost event, Emitter<LikeState> emit) async {
    try {
      final result = await PostService.unlikePost(
          postId: event.postId, userId: event.userId);
      emit(LikeUpdated(event.postId, false, result));
    } catch (e) {
      emit(LikeError('Failed to unlike post: $e'));
    }
  }
}
