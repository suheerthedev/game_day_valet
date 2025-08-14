import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddRentalsViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  TextEditingController searchController = TextEditingController();

  List<ItemModel> items = [];
  List<BundleModel> bundles = [];

  bool viewSmartSuggestions = false;

  final int tournamentId;
  AddRentalsViewModel({required this.tournamentId});

  void navigateToSearch(String searchQuery) {
    _navigationService.navigateToSearchView(
        isTournamentSearch: false, isItemSearch: true);
  }

  void toggleBundle(BundleModel bundle) {
    bundle.isSelected = !bundle.isSelected;
    rebuildUi();
  }

  void addItem(ItemModel item) {
    item.quantity++;
    rebuildUi();
  }

  void removeItem(ItemModel item) {
    if (item.quantity <= 0) return;
    item.quantity--;
    rebuildUi();
  }

  void toggleViewSmartSuggestions() {
    viewSmartSuggestions = !viewSmartSuggestions;
    rebuildUi();
  }

  void proceedToCheckout() {
    print(items[0].id);
    print(items[1].id);
    print(items[2].id);
    print(bundles[0].isSelected);
    _navigationService.navigateToCheckoutView(
        tournamentId: tournamentId, items: items, bundles: bundles);
  }

  void init() async {
    setBusy(true);
    try {
      await getItems();
      await getBundles();
    } catch (e) {
      logger.error("Error initializing: $e");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  Future<void> getItems() async {
    final url = ApiConfig.baseUrl + ApiConfig.items;

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
    }
  }

  Future<void> getBundles() async {
    final url = ApiConfig.baseUrl + ApiConfig.bundles;

    try {
      final response = await _apiService.get(url);
      logger.info("Bundles: $response");
      bundles = (response['data'] as List)
          .map((e) => BundleModel.fromJson(e))
          .toList();
    } on ApiException catch (e) {
      logger.error("Error getting bundles: ${e.message}");
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Error getting bundles: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
        message: "Something went wrong",
        variant: SnackbarType.error,
      );
    }
  }
}
