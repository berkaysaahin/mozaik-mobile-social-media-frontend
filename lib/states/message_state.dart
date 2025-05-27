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

  const MessageLoadSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
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
