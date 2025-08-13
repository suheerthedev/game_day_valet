import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/privacy_policy_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PrivacyPolicyViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  List<PrivacyPolicyModel> _privacyPolicies = [];

  List<PrivacyPolicyModel> get privacyPolicies => _privacyPolicies;

  void getPrivacyPolicy() async {
    setBusy(true);
    final url = ApiConfig.baseUrl + ApiConfig.privacyPolicyEndPoint;

    try {
      final response = await _apiService.get(url);
      logger.info("Privacy policy: $response");

      _privacyPolicies = (response['data'] as List)
          .map((e) => PrivacyPolicyModel.fromJson(e))
          .toList();

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error in getting privacy policy: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in getting privacy policy: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }
}
