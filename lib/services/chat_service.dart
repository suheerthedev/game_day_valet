import 'dart:convert';

import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/chat_model.dart';
import 'package:game_day_valet/models/message_model.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/pusher_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';

class ChatService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();
  final _pusherService = locator<PusherService>();
  final _userService = locator<UserService>();

  UserModel? get _user => _userService.currentUser;

  final ReactiveValue<List<ChatModel>> _conversations = ReactiveValue([]);
  final ReactiveValue<List<MessageModel>> _messages = ReactiveValue([]);

  List<ChatModel> get conversations => _conversations.value;
  List<MessageModel> get messages => _messages.value;

  String initalChatMessage = '';

  bool _isPusherInitialized = false;

  ChatService() {
    listenToReactiveValues([_conversations, _messages]);
  }

  Future<void> getUserConversations() async {
    final url = ApiConfig.baseUrl + ApiConfig.conversationsEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info("User conversations: $response");

      _conversations.value =
          (response as List).map((e) => ChatModel.fromJson(e)).toList();

      await initializePusher();
      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error getting user conversations: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error getting user conversations: $e");
      rethrow;
    }
  }

  Future<void> getConversationMessages(int conversationId) async {
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.conversationMessagesEndPoint}/$conversationId";

    try {
      final response = await _apiService.get(url);

      logger.info("Conversation messages: $response");

      for (var message in response) {
        _messages.value.insert(0, MessageModel.fromJson(message));
      }
      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error getting conversation messages: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error getting conversation messages: $e");
      rethrow;
    }
  }

  Future<void> getInitalChatMessage() async {
    final url = ApiConfig.baseUrl + ApiConfig.initalChatMessageEndPoint;

    try {
      final response = await _apiService.get(url);

      initalChatMessage = response['chat_initial_message'];

      logger.info("Inital chat message: $response");
    } on ApiException catch (e) {
      logger.error("Error getting inital chat message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error getting inital chat message: $e");
      rethrow;
    }
  }

  void clearMessages() {
    _messages.value = [];
  }

  Future<MessageModel> sendMessage(String message, int conversationId) async {
    final url = ApiConfig.baseUrl + ApiConfig.sendMessageEndPoint;

    final body = {
      'content': message,
      'conversation_id': conversationId.toString(),
    };

    try {
      final response = await _apiService.post(url, body);

      logger.info("Sent message: $response");

      _conversations.value
          .where((element) => element.id == conversationId)
          .first
          .messages
          ?.add(MessageModel.fromJson(response['message']));

      logger.info(
          "Messages: ${_conversations.value.where((element) => element.id == conversationId).first.messages}");

      _messages.value.insert(0, MessageModel.fromJson(response['message']));
      return MessageModel.fromJson(response['message']);
    } on ApiException catch (e) {
      logger.error("Errorg message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }

  Future<MessageModel> startConversation(String message) async {
    logger.info("Starting conversation: $message");
    final url = ApiConfig.baseUrl + ApiConfig.sendMessageEndPoint;

    try {
      final response = await _apiService.post(url, {
        'content': message,
        // 'conversation_id': null,
      });

      logger.info("Conversation started: $response");

      _messages.value.add(MessageModel.fromJson(response['message']));
      getUserConversations();
      notifyListeners();
      return MessageModel.fromJson(response['message']);
    } on ApiException catch (e) {
      logger.error("Error sending message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }

  Future<void> markMessageAsRead(int conversationId) async {
    final url =
        "${ApiConfig.baseUrl}${ApiConfig.markMessageAsReadEndPoint}/$conversationId";

    try {
      final response = await _apiService.post(url, {});

      logger.info("Marked message as read: $response");

      _conversations.value
          .where((element) => element.id == conversationId)
          .first
          .messages
          ?.last
          .isRead = 1;

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error sending message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }

  Future<void> initializePusher() async {
    if (_isPusherInitialized) return;

    try {
      await _pusherService.initialize();

      if (_user?.id != null) {
        await subscribeToChannel('conversation.${_user!.id.toString()}');
      }
      _isPusherInitialized = true;
      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error initializing Pusher: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error initializing Pusher: $e");
      rethrow;
    }
  }

  Future<void> subscribeToChannel(String channelName) async {
    await _pusherService.subscribeToChannel(
        channelName, _handleIncomingMessage);
    notifyListeners();
  }

  void _handleIncomingMessage(dynamic eventData) {
    try {
      logger.info("Handling in ChatService incoming message: $eventData");

      if (eventData.toString() == '{}') {
        print('No data received from Pusher');
        return;
      }

      final data = jsonDecode(eventData);

      _conversations.value
          .where((element) => element.id == data['message']['conversation_id'])
          .first
          .messages
          ?.add(MessageModel.fromJson(data['message']));

      //i want to udpate the response of the conversation when i recieve a message
      _conversations.value
          .where((conversation) =>
              conversation.id == data['message']['conversation_id'])
          .first
          .responder = UserModel.fromJson(data['message']['sender']);

      _messages.value.insert(0, MessageModel.fromJson(data['message']));

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error handling incoming message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error handling incoming message: $e");
      rethrow;
    }
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    await _pusherService.unsubscribeFromChannel(channelName);
    notifyListeners();
  }
}
