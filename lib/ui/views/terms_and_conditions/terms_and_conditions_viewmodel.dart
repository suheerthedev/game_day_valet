import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/terms_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TermsAndConditionsViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  List<TermsModel> _terms = [];

  List<TermsModel> get terms => _terms;

  String colorCode = '0xFFFFFFFF';

  void getTerms() async {
    setBusy(true);
    final url = ApiConfig.baseUrl + ApiConfig.termsAndConditionsEndPoint;

    try {
      final response = await _apiService.get(url);
      logger.info("Terms and conditions: $response");

      colorCode = response['color'] ?? '0xFFFFFFFF';

      _terms = (response['data'] as List)
          .map((e) => TermsModel.fromJson(e))
          .toList();

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error in getting terms and conditions: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in getting terms and conditions: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  // void onChatTap() {
  //   _navigationService.navigateToInboxView();
  // }
}
