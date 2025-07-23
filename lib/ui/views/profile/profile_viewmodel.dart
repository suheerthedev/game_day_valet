import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

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
}
