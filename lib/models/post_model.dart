class Post {
  final int id;
  final String username;
  final String handle;
  final String userId;
  final String content;
  final int comments;
  final DateTime timestamp;
  final String profilePic;
  final int likeCount;
  final int reblogCount;
  final bool hasLiked;
  final bool hasReblogged;
  final String visibility;
  final String? imageUrl;
  final Map<String, dynamic>? music;

  Post({
    required this.userId,
    required this.id,
    required this.username,
    required this.handle,
    required this.content,
    required this.comments,
    required this.timestamp,
    required this.profilePic,
    required this.likeCount,
    required this.reblogCount,
    required this.hasLiked,
    required this.hasReblogged,
    required this.visibility,
    this.imageUrl,
    this.music,
  });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? 'Unknown',
      handle: json['handle'] as String? ?? 'Unknown',
      content: json['content'] as String? ?? '',
      comments: int.tryParse(json['comments'].toString()) ?? 0,
      timestamp: DateTime.parse(
          json['timestamp'] as String? ?? DateTime.now().toIso8601String()),
      profilePic: json['profile_picture'] as String? ?? '',
      likeCount: int.tryParse(json['like_count'].toString()) ?? 0,
      reblogCount: int.tryParse(json['reblog_count'].toString()) ?? 0,
      userId: json['user_id'] as String? ?? '',
      hasLiked: json['has_liked'] as bool? ?? false,
      hasReblogged: json['has_reblogged'] as bool? ?? false,
      visibility: json['visibility'] as String? ?? 'public',
      imageUrl: json['image_url'] as String?,
      music: json['music'] != null
          ? Map<String, dynamic>.from(json['music'])
          : null,
    );
  }
}
