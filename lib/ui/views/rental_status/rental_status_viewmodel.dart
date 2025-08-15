import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
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

  bool get isRentalActive => true;

  Timer? timer; // Declare a Timer variable
  int timeRemaining = 25; // Example: 60 seconds
  bool isRunning = false;

  void onChatTap() {
    _navigationService.navigateToInboxView();
  }

  void init() {
    setBusy(true);
    rebuildUi();
    try {
      _rentalService.getRentalStatus(_rentalService.rentalBooking!.id);
      startPeriodicTimer();
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

  void startPeriodicTimer() {
    isRunning = true;
    rebuildUi();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (timeRemaining > 0) {
        timeRemaining--;

        logger.info('Time remaining: $timeRemaining');
        rebuildUi();
        // Update UI (e.g., using setState)
      } else {
        timer.cancel();
        logger.info('Countdown finished!');
        this.timer = null;
        isRunning = false;
        rebuildUi();
      }
    });
  }

  String getOrderId() {
    return '#1234567890';
  }

  String getEstimatedDeliveryTime() {
    return '30 minutes';
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_rentalService];
}
