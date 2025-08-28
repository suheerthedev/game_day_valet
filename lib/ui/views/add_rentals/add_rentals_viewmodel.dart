import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddRentalsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _rentalService = locator<RentalService>();

  TextEditingController searchController = TextEditingController();

  List<ItemModel> get items => _rentalService.items;
  List<BundleModel> get bundles => _rentalService.bundles;

  // bool viewSmartSuggestions = false;

  final int tournamentId;
  AddRentalsViewModel({required this.tournamentId});

  void navigateToSearch(String searchQuery) {
    _navigationService.navigateToSearchView(
        isTournamentSearch: false, isItemSearch: true);
  }

  void toggleBundle(BundleModel bundle) {
    bundle.isSelected = !bundle.isSelected;
    checkBundleQuantity();
    rebuildUi();
  }

  void addItem(ItemModel item) {
    item.quantity++;
    checkItemQuantity();
    rebuildUi();
  }

  void removeItem(ItemModel item) {
    if (item.quantity <= 0) return;
    item.quantity--;
    checkItemQuantity();
    rebuildUi();
  }

  // void toggleViewSmartSuggestions() {
  //   viewSmartSuggestions = !viewSmartSuggestions;
  //   rebuildUi();
  // }

  bool checkItemQuantity() {
    return items.any((item) => item.quantity > 0);
  }

  bool checkBundleQuantity() {
    return bundles.any((bundle) => bundle.isSelected);
  }

  bool get isProceedToCheckoutDisabled {
    return !checkItemQuantity() && !checkBundleQuantity();
  }

  Future<void> proceedToCheckout() async {
    await _navigationService.navigateToCheckoutView(
        tournamentId: tournamentId,
        items: items.where((item) => item.quantity > 0).toList(),
        bundles: bundles.where((bundle) => bundle.isSelected).toList());
    rebuildUi();
  }

  // Future<void> init() async {
  //   setBusy(true);
  //   try {
  //     await getItems();
  //     await getBundles();
  //     await getSettingsItems();
  //   } catch (e) {
  //     logger.error("Error initializing: $e");
  //     _snackbarService.showCustomSnackBar(
  //       message: "Something went wrong",
  //       variant: SnackbarType.error,
  //     );
  //   } finally {
  //     rebuildUi();
  //     setBusy(false);
  //   }
  // }

  // Future<void> getSettingsItems() async {
  //   try {
  //     await _rentalService.getSettingsItems();
  //   } on ApiException catch (e) {
  //     logger.error("Error getting settings items: ${e.message}");
  //     _snackbarService.showCustomSnackBar(
  //       message: e.message,
  //       variant: SnackbarType.error,
  //     );
  //   } catch (e) {
  //     logger.error("Error getting settings items: $e");
  //     _snackbarService.showCustomSnackBar(
  //       message: "Something went wrong",
  //       variant: SnackbarType.error,
  //     );
  //   }
  // }

  // Future<void> getItems() async {
  //   final url = "${ApiConfig.baseUrl}${ApiConfig.items}?limit=1000&page=1";

  //   try {
  //     final response = await _apiService.get(url);
  //     items =
  //         (response['data'] as List).map((e) => ItemModel.fromJson(e)).toList();
  //     logger.info("Items: $items");
  //   } on ApiException catch (e) {
  //     logger.error("Error getting items: ${e.message}");
  //     _snackbarService.showCustomSnackBar(
  //       message: e.message,
  //       variant: SnackbarType.error,
  //     );
  //   } catch (e) {
  //     logger.error("Error getting items: $e");
  //     _snackbarService.showCustomSnackBar(
  //       message: "Something went wrong",
  //       variant: SnackbarType.error,
  //     );
  //   }
  // }

  // Future<void> getBundles() async {
  //   final url = ApiConfig.baseUrl + ApiConfig.bundles;

  //   try {
  //     final response = await _apiService.get(url);
  //     logger.info("Bundles: $response");
  //     bundles = (response['data'] as List)
  //         .map((e) => BundleModel.fromJson(e))
  //         .toList();
  //   } on ApiException catch (e) {
  //     logger.error("Error getting bundles: ${e.message}");
  //     _snackbarService.showCustomSnackBar(
  //       message: e.message,
  //       variant: SnackbarType.error,
  //     );
  //   } catch (e) {
  //     logger.error("Error getting bundles: ${e.toString()}");
  //     _snackbarService.showCustomSnackBar(
  //       message: "Something went wrong",
  //       variant: SnackbarType.error,
  //     );
  //   }
  // }
}
