import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/chat_model.dart';
import 'package:game_day_valet/models/message_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class ChatService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  final ReactiveValue<List<ChatModel>> _conversations = ReactiveValue([]);
  final ReactiveValue<List<MessageModel>> _messages = ReactiveValue([]);

  List<ChatModel> get conversations => _conversations.value;
  List<MessageModel> get messages => _messages.value;

  ChatService() {
    listenToReactiveValues([_conversations]);
  }

  Future<void> getUserConversations() async {
    final url = ApiConfig.baseUrl + ApiConfig.conversationsEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info("User conversations: $response");

      _conversations.value =
          (response as List).map((e) => ChatModel.fromJson(e)).toList();
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

      for (var message in response) {
        _messages.value.insert(0, MessageModel.fromJson(message));
      }
    } on ApiException catch (e) {
      logger.error("Error getting conversation messages: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error getting conversation messages: $e");
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

      _messages.value.insert(0, MessageModel.fromJson(response['message']));
      return MessageModel.fromJson(response['message']);
    } on ApiException catch (e) {
      logger.error("Error sending message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }

  Future<MessageModel> startConversation(String message) async {
    final url = ApiConfig.baseUrl + ApiConfig.sendMessageEndPoint;

    try {
      final response = await _apiService.post(url, {
        'content': message,
        'conversation_id': null,
      });

      logger.info("Conversation started: $response");

      _messages.value.add(MessageModel.fromJson(response));
      return MessageModel.fromJson(response);
    } on ApiException catch (e) {
      logger.error("Error sending message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }
}
