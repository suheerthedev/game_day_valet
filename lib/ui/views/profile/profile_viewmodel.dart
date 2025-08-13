import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _secureStorageService = locator<SecureStorageService>();

  UserModel? get currentUser => _userService.currentUser;

  // ProfileViewModel() {
  //   _userService.addListener(notifyListeners);
  // }

  bool isLoggingOut = false;

  Future<void> onLogoutTap() async {
    isLoggingOut = true;
    rebuildUi();
    await Future.delayed(const Duration(seconds: 2));
    await _secureStorageService.deleteToken();
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

  void onReferAndEarnTap() {
    _navigationService.navigateToReferAndEarnView();
  }

  void onFrequentlyAskedQuestionsTap() {
    _navigationService.navigateToFaqView();
  }

  void onNotificationsTap() {}

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_userService];
}
