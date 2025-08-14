import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;
  final http.Client _client;

  AuthService({required this.baseUrl, required http.Client client})
      : _client = client;

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final body = jsonEncode({
      'user': email, // or username
      'pwd': password,
    });
    print('Request body: $body');
    final response = await _client.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user': email, 'pwd': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['accessToken'];
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<void> logout(String token) async {
    await _client.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
