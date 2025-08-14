import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mozaik/models/conversation_model.dart';

class ConversationService {
  final String baseUrl;
  final http.Client client;

  ConversationService({
    required this.baseUrl,
    required this.client,
  });

  Future<Conversation> createConversation({
    required String user1,
    required String user2,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/conversations/conversations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user1': user1,
          'user2': user2,
        }),
      );

      if (response.statusCode == 201) {
        return Conversation.fromJson(json.decode(response.body));
      } else {
        print(response.statusCode);
        throw Exception('Failed to create conversation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<List<Conversation>> getUserConversations(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/conversations/conversations/$userId');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return [];

        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((conv) => Conversation.fromJson(conv)).toList();
      }
      else if (response.statusCode == 404) {
        return [];
      }
      else {
        throw Exception('API Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load conversations: ${e.toString()}');
    }
  }


  Future<Conversation> getConversationById(String id) async {
    try {
       Uri uri = Uri.parse('$baseUrl/api/conversations/conversations/single/$id');
       print(uri);
      final response = await client.get(
        uri,
      );


      if (response.statusCode == 200) {
        return Conversation.fromJson(json.decode(response.body));
      }else if (response.statusCode == 404) {
        // User has no conversations, return empty list
        throw Exception('Conversation not found');
      }  else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load conversation: ${e.toString()}');
    }
  }

  Future<Conversation> findOrCreateConversation({
    required String user1,
    required String user2,
  }) async {
    try {
      final sortedUsers = [user1, user2]..sort();
      print(sortedUsers);
      final findResponse = await client.get(
        Uri.parse(
            '$baseUrl/api/conversations/conversations/find?user1=${sortedUsers[0]}&user2=${sortedUsers[1]}'),
      );

      if (findResponse.statusCode == 200) {
        final data = json.decode(findResponse.body);
        if (data != null) {
          return Conversation.fromJson(data);
        }
      }

      final createResponse = await client.post(
        Uri.parse('$baseUrl/api/conversations/conversations'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user1': sortedUsers[0], 'user2': sortedUsers[1]}),
      );

      if (createResponse.statusCode == 201) {
        return Conversation.fromJson(json.decode(createResponse.body));
      } else {
        throw Exception(
            'Failed to create conversation: ${createResponse.body}');
      }
    } catch (e) {
      throw Exception('Conversation error: ${e.toString()}');
    }
  }

  Future<void> deleteConversation(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/api/conversations/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete conversation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Conversation> updateLastMessage({
    required String conversationId,
    required String lastMessage,
  }) async {
    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/api/conversations/$conversationId/last-message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'last_message': lastMessage,
        }),
      );

      if (response.statusCode == 200) {
        return Conversation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update conversation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
