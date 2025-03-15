class Post {
  final int id;
  final String username;
  final String handle;
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
      id: json['id'] as int? ?? 0, // Default value if null
      username:
          json['username'] as String? ?? 'Unknown', // Default value if null
      handle: json['handle'] as String? ?? 'Unknown', // Default value if null
      content: json['content'] as String? ?? '', // Default value if null
      comments: int.tryParse(json['comments'].toString()) ?? 0,
      timestamp: DateTime.parse(json['timestamp'] as String? ??
          DateTime.now().toIso8601String()), // Default value if null
      profilePic:
          json['profile_picture'] as String? ?? '', // Default value if null
      likeCount: int.tryParse(json['like_count'].toString()) ?? 0,
      reblogCount: int.tryParse(json['reblog_count'].toString()) ?? 0,
      hasLiked: json['has_liked'] as bool? ?? false, // Default value if null
      hasReblogged:
          json['has_reblogged'] as bool? ?? false, // Default value if null
      visibility:
          json['visibility'] as String? ?? 'public', // Default value if null
      imageUrl: json['image_url'] as String?, // Nullable
      music: json['music'] != null
          ? Map<String, dynamic>.from(json['music'])
          : null, // Nullable
    );
  }
}
