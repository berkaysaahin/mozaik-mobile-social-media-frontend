import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;

  UserService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchUserById(String id, {required String token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/user?id=$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPublicUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/user?id=$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load public user: ${response.statusCode}');
    }
  }
}