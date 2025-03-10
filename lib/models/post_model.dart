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
  final Map<String, dynamic>? music;

  Post(
      {required this.id,
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
      this.music});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      username: json['username'] as String,
      handle: json['handle'] as String,
      content: json['content'] as String,
      comments: int.parse(json['comments'].toString()),
      timestamp: DateTime.parse(json['timestamp'] as String),
      profilePic: json['profile_picture'] as String,
      likeCount: int.parse(json['like_count'].toString()),
      reblogCount: int.parse(json['reblog_count'].toString()),
      hasLiked: json['has_liked'] as bool,
      hasReblogged: json['has_reblogged'] as bool,
      music: json['music'] != null
          ? Map<String, dynamic>.from(json['music'])
          : null,
    );
  }
}
