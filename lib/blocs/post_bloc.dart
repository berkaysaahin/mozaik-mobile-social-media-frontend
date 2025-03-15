import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/post_event.dart';
import 'package:mozaik/services/post_service.dart';
import 'package:mozaik/states/post_state_dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    // Register the CreatePostEvent handler
    on<CreatePostEvent>(_onCreatePostEvent);
  }

  // Event handler for CreatePostEvent
  Future<void> _onCreatePostEvent(
      CreatePostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading()); // Emit loading state

    try {
      final newPost = await PostService.createPost(
        userId: event.userId,
        content: event.content,
        spotifyTrackId: event.spotifyTrackId,
        visibility: event.visibility,
        imageUrl: event.imageUrl,
      );

      emit(PostCreated(newPost)); // Emit success state
    } catch (e) {
      emit(PostError('Failed to create post: $e')); // Emit error state
    }
  }
}
