import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/chat_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/chat_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InboxViewModel extends ReactiveViewModel {
  final _chatService = locator<ChatService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  List<ChatModel> get conversations => _chatService.conversations;

  void initialize() async {
    if (conversations.isEmpty) {
      await getUserConversations();
    }
  }

  Future<void> getUserConversations({bool refresh = false}) async {
    if (refresh) {
      conversations.clear();
    }
    setBusy(true);
    rebuildUi();
    try {
      await _chatService.getUserConversations();
    } on ApiException catch (e) {
      logger.error("Error getting user conversations: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error getting user conversations: $e");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void navigateToChatView(int conversationId) async {
    await _markMessageAsRead(conversationId);
    logger
        .info("Navigating to chat view with conversation id: $conversationId");
    _navigationService.navigateToChatView(conversationId: conversationId);
  }

  void startNewConversation() {
    _navigationService.navigateToChatView();
  }

  Future<void> _markMessageAsRead(int conversationId) async {
    try {
      await _chatService.markMessageAsRead(conversationId);
    } on ApiException catch (e) {
      logger.error("Error marking message as read: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error marking message as read: $e");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_chatService];
}
