import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool seen;
  final String? clientTag;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.seen = false,
    this.clientTag,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      seen: json['seen'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'sent_at': sentAt.toIso8601String(),
      'seen': seen,
      if (clientTag != null) 'clientTag': clientTag,
    };
  }

  String get formattedTime {
    return DateFormat('h:mm a').format(sentAt);
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final messageDate = DateTime(sentAt.year, sentAt.month, sentAt.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(sentAt);
    }
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    DateTime? sentAt,
    bool? seen,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      seen: seen ?? this.seen,
    );
  }

  @override
  List<Object?> get props =>
      [id, conversationId, senderId, content, sentAt, seen];
}
