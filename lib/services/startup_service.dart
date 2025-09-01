import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/chat_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/notification_service.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupService with ListenableServiceMixin {
  final _notificationService = locator<NotificationService>();
  final _userService = locator<UserService>();
  final _rentalService = locator<RentalService>();
  final _chatService = locator<ChatService>();
  final _snackbarService = locator<SnackbarService>();
  final _apiService = locator<ApiService>();
  final _secureStorageService = locator<SecureStorageService>();

  Future<dynamic> validateToken() async {
    final url = ApiConfig.baseUrl + ApiConfig.validateTokenEndPoint;

    final token = await _secureStorageService.getToken();

    try {
      final response = await _apiService.post(url, {
        'token': token,
      });
      logger.info("Token validated: $response");

      if (response['valid']) {
        return true;
      } else {
        await _apiService.unauthorized();
        notifyListeners();
        return false;
      }
    } on ApiException catch (e) {
      logger.error("Error validating token: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    }
  }

  Future<void> runTokenTasks() async {
    await _notificationService.getUserNotifications();
    await _userService.fetchCurrentUser();
    await getUserConversations();
    await _rentalService.init();
    await getInitalChatMessage();
  }

  Future<void> getUserConversations() async {
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
    }
  }

  Future<void> getInitalChatMessage() async {
    try {
      await _chatService.getInitalChatMessage();
    } on ApiException catch (e) {
      logger.error("Error getting inital chat message: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error getting inital chat message: $e");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    }
  }
}
