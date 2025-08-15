import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/chat_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _userService = locator<UserService>();
  final _chatService = locator<ChatService>();
  final _snackbarService = locator<SnackbarService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    final token = await _secureStorageService.getToken();

    if (token != null) {
      await _userService.fetchCurrentUser();
      await getUserConversations();
      await _navigationService.replaceWithMainView();
    } else {
      _navigationService.replaceWithOnboardingView();
    }
  }

  Future<void> getUserConversations() async {
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
}
