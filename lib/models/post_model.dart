class Post {
  final int id;
  final String username;
  final String handle;
  final String content;
  final int likes;
  final int retweets;
  final int comments;
  final DateTime timestamp;
  final String profilePic;

  Post({
    required this.id,
    required this.username,
    required this.handle,
    required this.content,
    required this.likes,
    required this.retweets,
    required this.comments,
    required this.timestamp,
    required this.profilePic,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      handle: json['handle'],
      content: json['content'],
      likes: json['likes'],
      retweets: json['retweets'],
      comments: json['comments'],
      timestamp: DateTime.parse(json['timestamp']),
      profilePic: json['profile_picture'],
    );
  }
}
