class User {
  final String id;
  final String username;
  final String handle;
  final String email;
  final String password;
  final DateTime createdAt;
  final String profilePic;
  final String cover;

  User({
    required this.id,
    required this.username,
    required this.handle,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.profilePic,
    required this.cover,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      handle: json['handle'],
      email: json['email'],
      password: json['password'],
      profilePic: json['profile_picture'],
      cover: json['cover'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
