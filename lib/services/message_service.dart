import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mozaik/models/message_model.dart';

class MessageService {
  static String baseUrl = dotenv.env['HOST_URL']!;

  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/conversations/conversations/$conversationId/messages?user_id=b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((m) => Message.fromJson(m)).toList();
      } else {
        throw Exception(
            'Failed to load messages. Status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Stack trace: $stackTrace');
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> sendMessage(String conversationId, String content) async {
    final url = '$baseUrl/api/conversations/messages';
    final body = json.encode({
      'conversation_id': conversationId,
      'content': content,
      'user_id': 'b2ecc8ae-9e16-42eb-915f-d2e1e2022f6c',
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    log('📥 Response Status: ${response.statusCode}');
    log('📥 Response Body: ${response.body}');

    if (response.statusCode == 201) {
      return Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/conversations/messages/$messageId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }
}
