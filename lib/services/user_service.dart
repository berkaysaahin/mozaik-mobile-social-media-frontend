import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mozaik/models/user_model.dart';

class UserService {
  final String baseUrl;
  final http.Client _client;

  UserService({
    required this.baseUrl,
    required http.Client client,
  }) : _client = client;

  Future<User> fetchUserById(String id, {required String token}) async {

    final response = await _client.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load user: ${response.statusCode}\n${response.body}',
      );
    }
  }

  Future<User> fetchPublicUserById(String id) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load public user: ${response.statusCode}\n${response.body}',
      );
    }
  }

  Future<User> updateUserProfile({
    required String userId,
    required String token,
    String? profilePic,
    String? cover,
    String? username,
    String? bio,
    String? handle,
    String? email,
  }) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        if (profilePic != null) 'profile_picture': profilePic,
        if (cover != null) 'cover': cover,
        if (username != null) 'username': username,
        if (bio != null) 'bio': bio,
        if (email != null) 'email': email,
        if (handle != null) 'handle': handle,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }
}
