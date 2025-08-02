import 'package:equatable/equatable.dart';
import 'package:mozaik/models/message_model.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageLoadInProgress extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageLoadSuccess extends MessageState {
  final List<Message> messages;
  final bool isConnected;
  final bool isSending;
  final String? error;

  const MessageLoadSuccess({
    required this.messages,
    this.isConnected = true,
    this.isSending = false,
    this.error,
  });

  @override
  List<Object?> get props => [messages, isConnected, isSending, error];

  MessageLoadSuccess copyWith({
    List<Message>? messages,
    bool? isConnected,
    bool? isSending,
    String? error,
  }) {
    return MessageLoadSuccess(
      messages: messages ?? this.messages,
      isConnected: isConnected ?? this.isConnected,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }
}

class MessageLoadFailure extends MessageState {
  final String error;

  const MessageLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class MessageOperationFailure extends MessageState {
  final String error;
  final List<Message> messages;

  const MessageOperationFailure({
    required this.error,
    required this.messages,
  });

  @override
  List<Object> get props => [error, messages];
}
