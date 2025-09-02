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

  void removeFromFavorites(int tournamentId, int index) async {
    final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

    favorites.removeAt(index);
    rebuildUi();

    try {
      final response = await _apiService
          .post(url, {"tournament_id": tournamentId.toString()});
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        message: response['message'],
      );
    } on ApiException catch (e) {
      logger.error("Error in removing from favorites: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } catch (e) {
      logger.error("Error in removing from favorites: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
    }
  }

  //  void toggleFavorite(int tournamentId) async {
  //   final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

  //   int index =
  //       tournamentsList.indexWhere((element) => element.id == tournamentId);

  //   int indexRecommended = recommendedTournamentsList
  //       .indexWhere((element) => element.id == tournamentId);

  //   // logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
  //   if (index != -1) {
  //     tournamentsList[index].isFavorite = !tournamentsList[index].isFavorite;
  //     rebuildUi();
  //   }

  //   if (indexRecommended != -1) {
  //     recommendedTournamentsList[indexRecommended].isFavorite =
  //         !recommendedTournamentsList[indexRecommended].isFavorite;
  //     rebuildUi();
  //   }
  //   // logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
  //   // logger.info(
  //   // "Is Favorite: ${recommendedTournamentsList[indexRecommended].isFavorite}");

  //   try {
  //     final response = await _apiService.post(url, {
  //       "tournament_id": tournamentId.toString(),
  //     });

  //     logger.info("Favorite toggled successfully. Response: $response");
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.success,
  //       message: response['message'],
  //     );
  //   } on ApiException catch (e) {
  //     logger.error("Error toggling favorite", e);
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.error,
  //       message: e.message,
  //     );
  //   } catch (e) {
  //     logger.error("Error toggling favorite", e);
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.error,
  //       message: e.toString(),
  //     );
  //   } finally {
  //     rebuildUi();
  //   }
  // }

  // void onChatTap() {
  //   _navigationService.navigateToInboxView();
  // }
}
