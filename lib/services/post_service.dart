import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mozaik/models/post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostService {
  static String baseUrl = dotenv.env['HOST_URL']!;

  static Future<List<Post>> fetchPosts({String? currentUserId}) async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/posts/get?user_id=$currentUserId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Post>> fetchPostsByUser(String id,
      {String? currentUserId}) async {
    final queryParam =
        currentUserId != null ? '?current_user_id=$currentUserId' : '';
    final url = '$baseUrl/api/posts/user/$id$queryParam';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        return jsonData.map((post) => Post.fromJson(post)).toList();
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Post> createPost({
    required String userId,
    required String content,
    String? spotifyTrackId,
    required String visibility,
    String? imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'content': content,
        'spotify_track_id': spotifyTrackId,
        'visibility': visibility,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      final dynamic jsonData = json.decode(response.body);
      return Post.fromJson(jsonData);
    } else {
      throw Exception('Failed to create post: ${response.body}');
    }
  }

  static Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete post: ${response.body}');
    }
  }

  static Future<int> likePost({
    required int postId,
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['like_count'] ?? 0;
    } else {
      throw Exception('Failed to like post: ${response.body}');
    }
  }

  static Future<int> unlikePost({
    required int postId,
    required String userId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId/like'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['like_count'] ?? 0;
    } else {
      throw Exception('Failed to unlike post: ${response.body}');
    }
  }
}
