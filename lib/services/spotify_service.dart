import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyService {
  static String baseUrl = dotenv.env['HOST_URL']!;

  // Search for tracks
  static Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/spotify/search?query=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((track) => track as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to search tracks');
    }
  }
}
