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
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
    // final hasDeepLink = await _deepLinkingService.processPendingUri();

    await _sharedPreferencesService.init();
    final token = await _secureStorageService.getToken();

    _deepLinkingService.isStartupInitiated = true;

    await _deepLinkingService.processPendingUri();

    final pendingRoute = _deepLinkingService.getPendingRoute();

    // logger.info('Has deep link: $hasDeepLink');
    // if (hasDeepLink) {
    //   // Deep link handled; do not perform any further navigation here.
    //   return;
    // }

    if (pendingRoute != null) {
      logger.info('Pending route: $pendingRoute');
      if (await _secureStorageService.hasToken()) {
        return;
      } else {
        _navigationService.clearStackAndShow(pendingRoute,
            arguments: SignUpViewArguments(
              referralCode: _deepLinkingService.getReferralCode(),
            ));

        _deepLinkingService.clearAll();
      }
    } else if (token != null) {
      await _startupService.runTokenTasks();
      await _navigationService.replaceWithMainView();
    } else {
      _navigationService.replaceWithOnboardingView();
    }
  }
}
