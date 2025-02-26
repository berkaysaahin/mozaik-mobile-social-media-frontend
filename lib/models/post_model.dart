class Post {
  final int id;
  final String username;
  final String handle;
  final String content;
  final int comments;
  final DateTime timestamp;
  final String profilePic;
  final int likeCount; // New field
  final int reblogCount; // New field
  final bool hasLiked; // New field
  final bool hasReblogged; // New field

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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      username: json['username'] as String,
      handle: json['handle'] as String,
      content: json['content'] as String,
      comments: int.parse(json['comments'].toString()), // Convert to int
      timestamp: DateTime.parse(json['timestamp'] as String),
      profilePic: json['profile_picture'] as String,
      likeCount: int.parse(json['like_count'].toString()), // Convert to int
      reblogCount: int.parse(json['reblog_count'].toString()), // Convert to int
      hasLiked: json['has_liked'] as bool,
      hasReblogged: json['has_reblogged'] as bool,
    );
  }
}
