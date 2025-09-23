import 'package:game_day_valet/services/deep_linking_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/shared_preferences_service.dart';
import 'package:game_day_valet/services/startup_service.dart';
import 'package:stacked/stacked.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _secureStorageService = locator<SecureStorageService>();
  // final _userService = locator<UserService>();
  // final _chatService = locator<ChatService>();
  // final _snackbarService = locator<SnackbarService>();
  final _deepLinkingService = locator<DeepLinkingService>();
  // final _rentalService = locator<RentalService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  // final _notificationService = locator<NotificationService>();
  final _startupService = locator<StartupService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    try {
      logger.info('Starting startup logic');

      await _sharedPreferencesService.init();
      logger.info('SharedPreferences initialized');

      // Add try-catch specifically for secure storage
      String? token;
      try {
        token = await _secureStorageService.getToken();
        logger.info('Token retrieved: ${token != null ? 'exists' : 'null'}');
      } catch (e) {
        logger.error('Failed to get token from secure storage: $e');
        // Clear storage and continue without token
        await _secureStorageService.clear();
        token = null;
      }

      _deepLinkingService.isStartupInitiated = true;

      final pendingRoute = _deepLinkingService.getPendingRoute();
      logger.info('Pending route: $pendingRoute');

      if (pendingRoute != null) {
        await _deepLinkingService.processPendingUri();
        if (token != null) {
          if (await _startupService.validateToken()) {
            await _startupService.runTokenTasks();
            await _navigationService.replaceWithMainView();
          }
        }
      } else if (token != null) {
        logger.info('Validating token...');
        if (await _startupService.validateToken()) {
          logger.info('Token valid, running token tasks...');
          await _startupService.runTokenTasks();
          await _navigationService.replaceWithMainView();
        }
      } else {
        logger.info('No token, navigating to onboarding');
        await Future.delayed(const Duration(seconds: 2));
        _navigationService.replaceWithOnboardingView();
      }
      logger.info('Startup logic completed');
    } catch (e, stackTrace) {
      logger.error('Error in startup logic: $e', e, stackTrace);
      // Fallback navigation
      _navigationService.replaceWithOnboardingView();
    }
  }
}
