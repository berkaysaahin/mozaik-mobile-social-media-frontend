import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIOService {
  static const _reconnectAttempts = 5;
  static const _reconnectDelay = Duration(seconds: 2);

  final String baseUrl = dotenv.env['HOST_URL']!;
  IO.Socket? _socket;
  String? _currentConversationId;

  final _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStreamController = StreamController<bool>.broadcast();
  final _errorStreamController = StreamController<dynamic>.broadcast();

  bool get isConnected => _socket?.connected ?? false;
  String? get currentConversationId => _currentConversationId;

  Stream<bool> get connectionStream => _connectionStreamController.stream;
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;
  Stream<dynamic> get errorStream => _errorStreamController.stream;

  void connect(String conversationId) {
    if (_currentConversationId == conversationId && isConnected) {
      return;
    }

    _disconnect(cleanStreams: false);

    _currentConversationId = conversationId;
    print('Connecting to conversation: $conversationId');

    try {
      _socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setReconnectionAttempts(_reconnectAttempts)
            .setReconnectionDelay(_reconnectDelay.inMilliseconds)
            .build(),
      );

      _setupSocketListeners();
    } catch (e) {
      _errorStreamController.add(e);
      _disconnect();
      rethrow;
    }
  }

  void _setupSocketListeners() {
    if (_socket == null) return;

    _socket!
      ..onConnect((_) {
        print('Socket connected to conversation $_currentConversationId');
        _connectionStreamController.add(true);
        _joinConversation();
      })
      ..onDisconnect((_) {
        print('Socket disconnected');
        _connectionStreamController.add(false);
      })
      ..onError((error) {
        print('Socket error: $error');
        _errorStreamController.add(error);
      })
      ..onReconnect((_) {
        print('Socket reconnected');
        _joinConversation();
      })
      ..on('newMessage', _handleIncomingMessage);
  }

  void _joinConversation() {
    if (_currentConversationId != null && isConnected) {
      _socket?.emit('joinConversation', _currentConversationId);
    }
  }

  void disconnect() {
    _disconnect(cleanStreams: false);
  }

  void _handleIncomingMessage(dynamic data) {
    try {
      final json = data is Map ? data : jsonDecode(data as String);
      final messageJson = json['message'] as Map<String, dynamic>;

      messageJson['_receivedAt'] = DateTime.now().millisecondsSinceEpoch;

      _messageStreamController.add(messageJson);
    } catch (e, stack) {
      log('Message parsing failed', error: e, stackTrace: stack);
    }
  }

  bool _validateMessage(Map<String, dynamic> message) {
    final messageData = message['message'] as Map<String, dynamic>?;
    if (messageData == null) return false;

    return messageData['conversation_id'] == _currentConversationId;
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!isConnected) throw SocketNotConnectedException();

    print('Sending message: ${jsonEncode(message)}');

    try {
      _socket?.emit(
        'sendMessage',
        {
          'conversationId': _currentConversationId,
          'message': message,
        },
      );
    } catch (e) {
      print('Send error: $e');
      rethrow;
    }
  }

  void _disconnect({bool cleanStreams = true}) {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
    _currentConversationId = null;

    if (cleanStreams) {
      if (!_messageStreamController.isClosed) {
        _messageStreamController.close();
      }
      if (!_connectionStreamController.isClosed) {
        _connectionStreamController.close();
      }
      if (!_errorStreamController.isClosed) {
        _errorStreamController.close();
      }
    }
  }

  void dispose() {
    _disconnect(cleanStreams: true);
  }
}

class SocketNotConnectedException implements Exception {
  @override
  String toString() => 'Socket not connected';
}
