import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/chat_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';

class ChatService with ListenableServiceMixin {
  final _apiService = locator<ApiService>();

  final ReactiveValue<List<ChatModel>> _conversations = ReactiveValue([]);

  List<ChatModel> get conversations => _conversations.value;

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
}
