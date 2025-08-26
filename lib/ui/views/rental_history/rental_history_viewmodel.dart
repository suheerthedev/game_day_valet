import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/rental_history_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RentalHistoryViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();
  final _rentalService = locator<RentalService>();

  List<RentalHistoryModel> rentalHistoryList = [];

  bool isLoading = false;

  void getRentalHistory() async {
    final url = ApiConfig.baseUrl + ApiConfig.rentalHistoryEndPoint;

    setBusy(true);

    try {
      final response = await _apiService.get(url);

      logger.info("Rental History: $response");
      for (var item in response['data']) {
        rentalHistoryList.add(RentalHistoryModel.fromJson(item));
      }
    } on ApiException catch (e) {
      logger.error(e.message);
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error(e.toString());
      _snackbarService.showCustomSnackBar(
          message: e.toString(), variant: SnackbarType.error);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void completePayment(BuildContext context, num amount, int rentalId) async {
    isLoading = true;
    rebuildUi();
    try {
      await _rentalService.compeletePayment(context, amount, rentalId);
    } on ApiException catch (e) {
      logger.error(e.message);
      _snackbarService.showCustomSnackBar(
          message: e.message, variant: SnackbarType.error);
    } catch (e) {
      logger.error(e.toString());
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong", variant: SnackbarType.error);
    } finally {
      isLoading = false;
      rebuildUi();
    }
  }

  // void onChatTap() {
  //   _navigationService.navigateToInboxView();
  // }
}
