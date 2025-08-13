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

      _messages.value =
          (response as List).map((e) => MessageModel.fromJson(e)).toList();
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

  Future<void> sendMessage(String message, int conversationId) async {}

  Future<MessageModel> startConversation(String message) async {
    final url = ApiConfig.baseUrl + ApiConfig.sendMessageEndPoint;

    try {
      final response = await _apiService.get(url);

      return MessageModel.fromJson(response['message']);
    } on ApiException catch (e) {
      logger.error("Error sending message: ${e.message}");
      rethrow;
    } catch (e) {
      logger.error("Error sending message: $e");
      rethrow;
    }
  }
}
