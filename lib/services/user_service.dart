import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mozaik/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  static String baseUrl = dotenv.env['HOST_URL']!;

  static Future<User> fetchUserByHandle(String handle) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/user?handle=$handle'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
