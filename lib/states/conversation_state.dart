import 'package:equatable/equatable.dart';
import 'package:mozaik/models/conversation_model.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoadInProgress extends ConversationState {}

class ConversationLoadSuccess extends ConversationState {
  final List<Conversation> conversations;

  const ConversationLoadSuccess(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ConversationLoadFailure extends ConversationState {
  final String error;

  const ConversationLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
