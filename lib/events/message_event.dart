import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class LoadMessages extends MessageEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class SendMessage extends MessageEvent {
  final String conversationId;
  final String content;

  const SendMessage(this.conversationId, this.content);

  @override
  List<Object> get props => [conversationId, content];
}

class DeleteMessage extends MessageEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object> get props => [messageId];
}
