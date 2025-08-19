import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/favorite_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FavoritesViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  List<FavoriteModel> favorites = [];

  void getFavorites() async {
    setBusy(true);
    final url = ApiConfig.baseUrl + ApiConfig.favoriteEndPoint;

    try {
      final response = await _apiService.get(url);

      logger.info(response.toString());

      for (var favorite in response['data']) {
        favorites.add(FavoriteModel.fromJson(favorite));
      }
    } on ApiException catch (e) {
      logger.error("Error in Favorites from ViewModel: ${e.message}");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error in Favorites from ViewModel: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      setBusy(false);
      rebuildUi();
    }
  }

  // void onChatTap() {
  //   _navigationService.navigateToInboxView();
  // }
}
