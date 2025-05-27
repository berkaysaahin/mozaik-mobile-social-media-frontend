import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/message_event.dart';
import 'package:mozaik/models/message_model.dart';
import 'package:mozaik/services/message_service.dart';
import 'package:mozaik/states/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageService _messageService;

  MessageBloc({required MessageService messageService})
      : _messageService = messageService,
        super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoadInProgress());
    try {
      final messages = await _messageService.getMessages(event.conversationId);
      emit(MessageLoadSuccess(messages: messages));
    } catch (e) {
      emit(MessageLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    if (state is MessageLoadSuccess) {
      try {
        final message = await _messageService.sendMessage(
          event.conversationId,
          event.content,
        );

        final updatedMessages = List<Message>.from(
          (state as MessageLoadSuccess).messages,
        )..add(message);

        emit(MessageLoadSuccess(messages: updatedMessages));
      } catch (e) {
        log('SendMessage error: $e');
        emit(MessageOperationFailure(
          error: e.toString(),
          messages: (state as MessageLoadSuccess).messages,
        ));
      }
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageState> emit,
  ) async {
    if (state is MessageLoadSuccess) {
      try {
        await _messageService.deleteMessage(event.messageId);

        final updatedMessages = List<Message>.from(
          (state as MessageLoadSuccess).messages,
        )..removeWhere((m) => m.id == event.messageId);

        emit(MessageLoadSuccess(messages: updatedMessages));
      } catch (e) {
        emit(MessageOperationFailure(
          error: e.toString(),
          messages: (state as MessageLoadSuccess).messages,
        ));
      }
    }
  }
}
