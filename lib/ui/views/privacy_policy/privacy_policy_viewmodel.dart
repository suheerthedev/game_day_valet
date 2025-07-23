import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PrivacyPolicyViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onChatTap() {
    _navigationService.navigateToChatView();
  }
}
