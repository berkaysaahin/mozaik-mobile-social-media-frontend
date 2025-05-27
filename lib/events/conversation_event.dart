import 'package:equatable/equatable.dart';
import 'package:mozaik/models/conversation_model.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
}

class LoadConversations extends ConversationEvent {
  final String userId;

  const LoadConversations(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddConversation extends ConversationEvent {
  final Conversation conversation;

  const AddConversation(this.conversation);

  @override
  List<Object> get props => [conversation];
}

class UpdateConversation extends ConversationEvent {
  final String conversationId;
  final String lastMessage;
  final DateTime lastMessageTime;

  const UpdateConversation({
    required this.conversationId,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  @override
  List<Object> get props => [conversationId, lastMessage, lastMessageTime];
}
