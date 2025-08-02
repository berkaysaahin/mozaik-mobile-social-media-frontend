import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/message_event.dart';
import 'package:mozaik/models/message_model.dart';
import 'package:mozaik/services/message_service.dart';
import 'package:mozaik/services/socket_service.dart';
import 'package:mozaik/states/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageService _messageService;
  final SocketIOService _socketService;

  StreamSubscription? _socketSubscription;
  StreamSubscription? _connectionSubscription;
  String? _currentConversationId;
  bool _isDisposed = false;

  MessageBloc({
    required MessageService messageService,
    required SocketIOService socketService,
  })  : _messageService = messageService,
        _socketService = socketService,
        super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<MessageErrorOccurred>(_onMessageError);
    on<SocketConnected>(_onSocketConnected);
    on<SocketDisconnected>(_onSocketDisconnected);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    if (_isDisposed) return;

    emit(MessageLoadInProgress());

    try {
      final messages = await _messageService.getMessages(event.conversationId);
      _currentConversationId = event.conversationId;

      if (_isDisposed) return;

      if (_socketService.currentConversationId != event.conversationId) {
        _socketService.disconnect();
        _socketService.connect(event.conversationId);
        _setupSocketListeners();
      }

      emit(MessageLoadSuccess(messages: messages));
    } catch (e, stacktrace) {
      log('Error loading messages', error: e, stackTrace: stacktrace);
      if (!_isDisposed) {
        emit(MessageLoadFailure(error: 'Failed to load messages'));
      }
    }
  }

  void _setupSocketListeners() {
    _socketSubscription?.cancel();
    _connectionSubscription?.cancel();

    _socketSubscription = _socketService.messageStream.listen(
      (data) {
        if (_isDisposed) return;
        try {
          final message = Message.fromJson(data);
          if (message.conversationId == _currentConversationId) {
            add(MessageReceived(message));
          }
        } catch (e) {
          add(MessageErrorOccurred('Invalid message format'));
        }
      },
      onError: (error) {
        if (!_isDisposed) {
          add(MessageErrorOccurred('Socket error: $error'));
        }
      },
    );

    _connectionSubscription = _socketService.connectionStream.listen(
      (isConnected) {
        if (_isDisposed) return;
        if (isConnected) {
          add(SocketConnected());
        } else {
          add(SocketDisconnected());
        }
      },
      onError: (error) {
        if (!_isDisposed) {
          add(MessageErrorOccurred('Connection error: $error'));
        }
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<MessageState> emit,
  ) async {
    if (_isDisposed || state is! MessageLoadSuccess) return;

    try {
      final clientTag = 'client-${DateTime.now().millisecondsSinceEpoch}';
      final tempMessage = Message(
        id: clientTag,
        conversationId: event.conversationId,
        senderId: 'b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c',
        content: event.content,
        sentAt: DateTime.now(),
        seen: false,
        clientTag: clientTag,
      );

      final state1 = state as MessageLoadSuccess;
      emit(state1.copyWith(
        messages: [...state1.messages, tempMessage],
        isSending: true,
      ));

      await _messageService.sendMessage(
        event.conversationId,
        event.content,
      );

      if (_isDisposed || state is! MessageLoadSuccess) return;

      final currentState = state as MessageLoadSuccess;
      emit(currentState.copyWith(isSending: false));
    } catch (e, stackTrace) {
      log('Send message error', error: e, stackTrace: stackTrace);
      if (_isDisposed || state is! MessageLoadSuccess) return;

      final errorState = state as MessageLoadSuccess;
      final updatedMessages = errorState.messages
          .where((m) => !m.id.startsWith('client-'))
          .toList();

      emit(errorState.copyWith(
        messages: updatedMessages,
        error: 'Failed to send message',
        isSending: false,
      ));
    }
  }

  void _onMessageReceived(MessageReceived event, Emitter<MessageState> emit) {
    if (_isDisposed || state is! MessageLoadSuccess) return;

    final currentState = state as MessageLoadSuccess;
    final newMessage = event.message;

    final updatedMessages = currentState.messages.where((m) {
      final isTemp = m.clientTag != null;
      final isSame = isTemp &&
          m.content == newMessage.content &&
          m.senderId == newMessage.senderId;
      return !isSame && m.id != newMessage.id;
    }).toList();

    final alreadyExists = updatedMessages.any((m) => m.id == newMessage.id);
    if (alreadyExists) {
      log('Skipping already existing real message: ${newMessage.id}');
      return;
    }

    updatedMessages.insert(0, newMessage);

    if (updatedMessages.length > 100) {
      updatedMessages.removeRange(100, updatedMessages.length);
    }

    emit(currentState.copyWith(messages: updatedMessages));
  }

  void _onMessageError(
    MessageErrorOccurred event,
    Emitter<MessageState> emit,
  ) {
    if (_isDisposed) return;

    if (state is MessageLoadSuccess) {
      emit((state as MessageLoadSuccess).copyWith(error: event.error));
    } else {
      emit(MessageLoadFailure(error: event.error));
    }
  }

  void _onSocketConnected(
    SocketConnected event,
    Emitter<MessageState> emit,
  ) {
    if (_isDisposed || state is! MessageLoadSuccess) return;
    emit((state as MessageLoadSuccess).copyWith(isConnected: true));
  }

  void _onSocketDisconnected(
    SocketDisconnected event,
    Emitter<MessageState> emit,
  ) {
    if (_isDisposed || state is! MessageLoadSuccess) return;
    emit((state as MessageLoadSuccess).copyWith(isConnected: false));
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    _socketSubscription?.cancel();
    _connectionSubscription?.cancel();
    _socketService.disconnect();
    return super.close();
  }
}
