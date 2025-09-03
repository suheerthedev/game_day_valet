import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  final bool isTournamentSearch;
  final bool isItemSearch;
  SearchViewModel(
      {required this.isTournamentSearch, required this.isItemSearch});

  List<TournamentModel> tournaments = [];
  List<ItemModel> items = [];

  String searchQuery = '';

  int currentPage = 1;

  bool hasMoreResults = false;

  bool isLoading = false;

  int? lastPage;

  void addItem(ItemModel item) {
    item.quantity++;
    rebuildUi();
  }

  void removeItem(ItemModel item) {
    if (item.quantity <= 0) return;
    item.quantity--;
    rebuildUi();
  }

  void init() {
    currentPage = 1;
    isLoading = false;
    hasMoreResults = false;
    searchQuery = '';
    tournaments = [];
    items = [];
    lastPage = null;
  }

  Future<void> searchTournaments(String query) async {
    tournaments = [];
    logger.info('Searching tournaments with query: $query');
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsEndPoint}?search=$query&limit=10&page=$currentPage';

    logger.info('URL: $url');
    setBusy(true);
    rebuildUi();

    currentPage = 1;
    isLoading = false;
    hasMoreResults = true;
    searchQuery = query;
    try {
      final response = await _apiService.get(url);

      logger.info('Response: $response');

      if (response.containsKey('meta')) {
        if (response['meta'].containsKey('last_page')) {
          lastPage = response['meta']['last_page'];
        }
      }

      final responseTournaments = (response['data'] as List)
          .map((tournament) => TournamentModel.fromJson(tournament))
          .toList();

      responseTournaments.length >= 10
          ? hasMoreResults = true
          : hasMoreResults = false;

      tournaments.addAll(responseTournaments);

      logger.info("Tournaments length: ${tournaments.length.toString()}");
    } on ApiException catch (e) {
      logger.error("Error searching tournaments: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error searching tournaments: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: 'Something went wrong', variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    // Format date as YYYY-MM-DD
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    logger.info('Selected date: $formattedDate');

    // Clear any existing search text
    searchController.clear();

    // Perform search with the formatted date
    searchTournaments(formattedDate);
  }

  void loadMoreTournaments() async {
    if (!hasMoreResults && isLoading) return;

    isLoading = true;
    rebuildUi();
    currentPage++;

    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsEndPoint}?search=$searchQuery&limit=10&page=$currentPage';

    try {
      final response = await _apiService.get(url);

      final newTournaments = (response['data'] as List)
          .map((tournament) => TournamentModel.fromJson(tournament))
          .toList();

      newTournaments.length >= 10
          ? hasMoreResults = true
          : hasMoreResults = false;

      tournaments.addAll(newTournaments);

      logger.info("Tournaments length: ${tournaments.length.toString()}");
      isLoading = false;
    } on ApiException catch (e) {
      logger.error("Error loading more tournaments: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error loading more tournaments: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: 'Something went wrong', variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  Future<void> searchItems(String query) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.items}?search=$query&limit=10&page=$currentPage';
    setBusy(true);
    rebuildUi();

    currentPage = 1;
    isLoading = false;
    hasMoreResults = true;
    searchQuery = query;
    try {
      final response = await _apiService.get(url);

      if (response.containsKey('meta')) {
        if (response['meta'].containsKey('last_page')) {
          lastPage = response['meta']['last_page'];
        }
      }

      final responseItems = (response['data'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList();

      responseItems.length >= 10
          ? hasMoreResults = true
          : hasMoreResults = false;

      items.addAll(responseItems);

      logger.info("Items length: ${items.length.toString()}");
    } on ApiException catch (e) {
      logger.error("Error searching items: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error searching items: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: e.toString(), variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void loadMoreItems() async {
    if (!hasMoreResults && isLoading) return;

    isLoading = true;
    rebuildUi();
    currentPage++;

    final url =
        '${ApiConfig.baseUrl}${ApiConfig.items}?search=$searchQuery&limit=10&page=$currentPage';

    try {
      final response = await _apiService.get(url);

      final newItems = (response['data'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList();

      newItems.length >= 10 ? hasMoreResults = true : hasMoreResults = false;

      items.addAll(newItems);
      isLoading = false;
    } on ApiException catch (e) {
      logger.error("Error loading more items: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error loading more items: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: 'Something went wrong', variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void navigateToRentalBook(int tournamentId) {
    _navigationService.navigateToAddRentalsView(tournamentId: tournamentId);
  }

  void toggleFavorite(int tournamentId) async {
    final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

    int index = tournaments.indexWhere((element) => element.id == tournamentId);

    if (index != -1) {
      tournaments[index].isFavorite = !tournaments[index].isFavorite;
      rebuildUi();
    }

    try {
      final response = await _apiService.post(url, {
        "tournament_id": tournamentId.toString(),
      });

      logger.info("Favorite toggled successfully. Response: $response");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        message: response['message'],
      );
    } on ApiException catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
    }
  }
}
