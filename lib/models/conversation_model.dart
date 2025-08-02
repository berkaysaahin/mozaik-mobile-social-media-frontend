import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Conversation extends Equatable {
  final String id;
  final String user1;
  final String user2;
  final DateTime createdAt;
  final String user1Username;
  final String user2Username;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String user2ProfilePicture;
  final String user2Handle;
  final String user1ProfilePicture;
  final String user1Handle;

  const Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.user2ProfilePicture,
    required this.user2Handle,
    required this.user1ProfilePicture,
    required this.user1Handle,
    required this.user1Username,
    required this.user2Username,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      user1: json['user1'] as String,
      user2: json['user2'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      user1Username: (json['user1_username'] as String?) ?? 'Unknown',
      user1ProfilePicture: (json['user1_profile_picture'] as String?) ?? '',
      user1Handle: (json['user1_handle'] as String?) ?? '',
      user2ProfilePicture: (json['user2_profile_picture'] as String?) ?? '',
      user2Handle: (json['user2_handle'] as String?) ?? '',
      user2Username: (json['user2_username'] as String?) ?? 'Unknown',
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1': user1,
      'user2': user2,
      'created_at': createdAt.toIso8601String(),
      'user1_username': user1Username,
      'user1_profile_picture': user1ProfilePicture,
      'user1_handle': user1Handle,
      'user2_profile_picture': user2ProfilePicture,
      'user2_handle': user2Handle,
      'user2_username': user2Username,
      if (lastMessage != null) 'last_message': lastMessage,
      if (lastMessageTime != null)
        'last_message_time': lastMessageTime!.toIso8601String(),
    };
  }

  String getOtherParticipantUsername(String currentUserId) =>
      user1 == currentUserId ? user2Username : user1Username;

  String getOtherParticipantHandle(String currentUserId) =>
      user1 == currentUserId ? user2Handle : user1Handle;

  String getOtherParticipantProfilePicture(String currentUserId) =>
      user1 == currentUserId ? user2ProfilePicture : user1ProfilePicture;

  String get formattedLastMessageTime {
    if (lastMessageTime == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
        lastMessageTime!.year, lastMessageTime!.month, lastMessageTime!.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(lastMessageTime!);
    } else {
      return DateFormat('MMM d').format(lastMessageTime!);
    }
  }

  /// Creates a copy with updated fields
  Conversation copyWith({
    String? id,
    String? user1,
    String? user2,
    DateTime? createdAt,
    String? user1Username,
    String? user2ProfilePicture,
    String? user2Handle,
    String? user2Username,
    String? lastMessage,
    String? user1ProfilePicture,
    String? user1Handle,
    DateTime? lastMessageTime,
  }) {
    return Conversation(
      id: id ?? this.id,
      user1: user1 ?? this.user1,
      user2ProfilePicture: user2ProfilePicture ?? this.user2ProfilePicture,
      user2Handle: user2Handle ?? this.user2Handle,
      user1ProfilePicture: user1ProfilePicture ?? this.user1ProfilePicture,
      user1Handle: user1Handle ?? this.user1Handle,
      user2: user2 ?? this.user2,
      createdAt: createdAt ?? this.createdAt,
      user1Username: user1Username ?? this.user1Username,
      user2Username: user2Username ?? this.user2Username,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1,
        user2,
        createdAt,
        user1Username,
        user1Handle,
        user1ProfilePicture,
        user2Username,
        user2Handle,
        user2ProfilePicture,
        lastMessage,
        lastMessageTime,
      ];
}
