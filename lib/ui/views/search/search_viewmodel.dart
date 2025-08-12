import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();

  TextEditingController searchController = TextEditingController();

  final bool isTournamentSearch;
  final bool isItemSearch;
  SearchViewModel(
      {required this.isTournamentSearch, required this.isItemSearch});

  List<TournamentModel> tournaments = [];

  Future<void> searchTournaments(String searchQuery) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsEndPoint}?search=$searchQuery';
    setBusy(true);
    rebuildUi();
    try {
      final response = await _apiService.get(url);

      for (var tournament in response['data']) {
        tournaments.add(TournamentModel.fromJson(tournament));
      }
      logger.info("Tournaments length: ${tournaments.length.toString()}");
    } on ApiException catch (e) {
      logger.error("Error searching tournaments: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error searching tournaments: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: e.toString(), variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
