class User {
  final String userId;
  final String username;
  final String handle;
  final String email;
  final DateTime createdAt;
  final String profilePic;
  final String cover;
  final bool isNewUser;
  final bool hasPassword;
  final int followers;
  final int following;
  final String? bio;

  User({
    required this.userId,
    required this.username,
    required this.handle,
    required this.email,
    required this.createdAt,
    required this.profilePic,
    required this.cover,
    required this.isNewUser,
    required this.hasPassword,
    required this.followers,
    required this.following,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      username: json['username'],
      handle: json['handle'],
      email: json['email'],
      profilePic: json['profile_picture'],
      cover: json['cover'],
      createdAt: DateTime.parse(json['createdAt']),
      isNewUser: json['isNewUser'] ?? false,
      hasPassword: json['hasPassword'] ?? false,
      followers: json['followers'],
      following: json['following'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': username,
      'email': email,
      'handle': handle,
      'profile_picture': profilePic,
      'cover': cover,
      'createdAt': createdAt.toIso8601String(),
      'isNewUser': isNewUser,
      'hasPassword': hasPassword,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }
}
