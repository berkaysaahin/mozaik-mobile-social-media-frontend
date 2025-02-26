import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mozaik/models/post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostService {
  static String baseUrl = dotenv.env['HOST_URL']!;

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/posts/get?user_id=ca4739ee-02a9-495f-ad96-e8bb851024d2'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Post>> fetchPostsByUser(String handle) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/posts/user/$handle'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts for user: $handle');
    }
  }
}
