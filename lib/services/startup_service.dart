import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/chat_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/notification_service.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupService {
  final _notificationService = locator<NotificationService>();
  final _userService = locator<UserService>();
  final _rentalService = locator<RentalService>();
  final _chatService = locator<ChatService>();
  final _snackbarService = locator<SnackbarService>();

  Future<void> runTokenTasks() async {
    await _notificationService.getUserNotifications();
    await _userService.fetchCurrentUser();
    await getUserConversations();
    await _rentalService.init();
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
}
