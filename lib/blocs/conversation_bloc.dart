import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/conversation_event.dart';
import 'package:mozaik/models/conversation_model.dart';
import 'package:mozaik/services/conversation_service.dart';
import 'package:mozaik/states/conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationService _conversationService;

  ConversationBloc({required ConversationService conversationService})
      : _conversationService = conversationService,
        super(ConversationInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<AddConversation>(_onAddConversation);
    on<UpdateConversation>(_onUpdateConversation);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationLoadInProgress());
    try {
      final conversations =
          await _conversationService.getUserConversations(event.userId);
      emit(ConversationLoadSuccess(conversations));
    } catch (e) {
      emit(ConversationLoadFailure(e.toString()));
    }
  }

  void _onAddConversation(
    AddConversation event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoadSuccess) {
      final updatedConversations = List<Conversation>.from(
        (state as ConversationLoadSuccess).conversations,
      )..insert(0, event.conversation);
      emit(ConversationLoadSuccess(updatedConversations));
    }
  }

  void _onUpdateConversation(
    UpdateConversation event,
    Emitter<ConversationState> emit,
  ) {
    if (state is ConversationLoadSuccess) {
      final updatedConversations = (state as ConversationLoadSuccess)
          .conversations
          .map((conv) => conv.id == event.conversationId
              ? conv.copyWith(
                  lastMessage: event.lastMessage,
                  lastMessageTime: event.lastMessageTime,
                )
              : conv)
          .toList();
      emit(ConversationLoadSuccess(updatedConversations));
    }
  }
}
