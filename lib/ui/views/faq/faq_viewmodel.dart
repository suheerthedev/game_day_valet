import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/faq_item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FaqViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  List<FaqItemModel> faqItems = [];

  void toggleExpansion(int index) {
    faqItems[index].isExpanded = !faqItems[index].isExpanded;
    rebuildUi();
  }

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }

  void getFaqs() async {
    setBusy(true);
    final url = ApiConfig.baseUrl + ApiConfig.faqsEndPoint;

    try {
      final response = await _apiService.get(url);
      logger.info("Faqs: $response");
      faqItems = (response['data'] as List)
          .map((e) => FaqItemModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error in getting faqs: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in getting faqs: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
