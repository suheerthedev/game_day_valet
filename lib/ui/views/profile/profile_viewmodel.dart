import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:game_day_valet/services/shared_preferences_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _sharedPreferencesService = locator<SharedPreferencesService>();
  final _rentalService = locator<RentalService>();
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();
  UserModel? get currentUser => _userService.currentUser;

  // ProfileViewModel() {
  //   _userService.addListener(notifyListeners);
  // }

  bool isLoggingOut = false;

  bool? isNotificationsEnabled;

  void init() async {
    isNotificationsEnabled = currentUser?.isNotification ?? false;
    // isNotificationsEnabled =
    //     await _sharedPreferencesService.getBool('notifications_enabled');
    // if (isNotificationsEnabled == null) {
    //   isNotificationsEnabled = false;
    //   await _sharedPreferencesService.setBool(
    //       'notifications_enabled', isNotificationsEnabled!);
    // }
    rebuildUi();
  }

  Future<void> onLogoutTap() async {
    isLoggingOut = true;
    rebuildUi();
    await Future.delayed(const Duration(seconds: 2));
    // Reset rental subscriptions/state and remove any persisted rental id
    await _rentalService.reset();
    await _sharedPreferencesService.remove('rental_id');
    await _secureStorageService.deleteToken();
    await _sharedPreferencesService.clear();
    _userService.clearUser();
    await _navigationService.clearStackAndShow(Routes.signUpView);
    isLoggingOut = false;
  }

  void onEditProfileTap() {
    _navigationService.navigateToEditProfileView();
  }

  void onRentalHistoryTap() {
    _navigationService.navigateToRentalHistoryView();
  }

  void onFavoritesTap() {
    _navigationService.navigateToFavoritesView();
  }

  void onPrivacyPolicyTap() {
    _navigationService.navigateToPrivacyPolicyView();
  }

  void onTermsAndConditionsTap() {
    _navigationService.navigateToTermsAndConditionsView();
  }

  void onReferAndEarnTap() {
    _navigationService.navigateToReferAndEarnView();
  }

  void onFrequentlyAskedQuestionsTap() {
    _navigationService.navigateToFaqView();
  }

  void onNotificationsTap() async {
    isNotificationsEnabled = !isNotificationsEnabled!;

    rebuildUi();
    final url = ApiConfig.baseUrl + ApiConfig.toggleNotificationsEndPoint;

    try {
      final response = await _apiService.post(url, {});

      if (response.containsKey('enabled')) {
        _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);
      }
    } on ApiException catch (e) {
      logger.error("Error in updating user: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in updating user: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
    }
  }

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }

  void toggleNotifications() {
    isNotificationsEnabled = !isNotificationsEnabled!;
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_userService];
}
