import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/models/rental_booking_model.dart';
import 'package:game_day_valet/models/rental_status_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RentalStatusViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _rentalService = locator<RentalService>();

  TextEditingController specialInstructionsController = TextEditingController();
  TextEditingController googleReviewController = TextEditingController();

  List<RentalStatusModel> get rentalStatus => _rentalService.rentalStatus;

  RentalBookingModel? get rentalBooking => _rentalService.rentalBooking;

  bool get isRentalActive => true;

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }

  RentalStatusViewModel() {
    init();
  }
  void init() {
    setBusy(true);
    rebuildUi();
    try {
      _rentalService.getRentalStatus(rentalBooking!.id);
    } on ApiException catch (e) {
      logger.error('Error in intializing: ${e.message}');
    } catch (e) {
      logger.error('Error in intializing rental status: $e');
      rethrow;
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_rentalService];
}
