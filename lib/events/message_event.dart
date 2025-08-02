import 'package:equatable/equatable.dart';
import 'package:mozaik/models/message_model.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class LoadMessages extends MessageEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class MessageReceived extends MessageEvent {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessage extends MessageEvent {
  final String conversationId;
  final String content;

  const SendMessage(this.conversationId, this.content);

  @override
  List<Object> get props => [conversationId, content];
}

class MessageErrorOccurred extends MessageEvent {
  final String error;

  const MessageErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteMessage extends MessageEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object> get props => [messageId];
}

class SocketConnected extends MessageEvent {
  @override
  List<Object> get props => [];
}

class SocketDisconnected extends MessageEvent {
  @override
  List<Object> get props => [];
}

class UserTyping extends MessageEvent {
  final String conversationId;
  final String userId;
  final bool isTyping;

  const UserTyping(this.conversationId, this.userId, this.isTyping);

  @override
  List<Object> get props => [conversationId, userId, isTyping];
}

class MarkMessagesAsRead extends MessageEvent {
  final String conversationId;
  final List<String> messageIds;

  const MarkMessagesAsRead(this.conversationId, this.messageIds);

  @override
  List<Object> get props => [conversationId, messageIds];
}
