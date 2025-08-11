import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddRentalsViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  List<ItemModel> items = [];

  Future<void> getItems() async {
    final url = ApiConfig.baseUrl + ApiConfig.items;
    setBusy(true);
    try {
      final response = await _apiService.get(url);
      items =
          (response['data'] as List).map((e) => ItemModel.fromJson(e)).toList();
      logger.info("Items: $items");
    } on ApiException catch (e) {
      logger.error("Error getting items: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error getting items: $e");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
