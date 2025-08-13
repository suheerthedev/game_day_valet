import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderTrackingStep {
  final String title;
  final String timestamp;
  final bool isCompleted;

  OrderTrackingStep({
    required this.title,
    required this.timestamp,
    required this.isCompleted,
  });
}

class RentalStatusViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  TextEditingController specialInstructionsController = TextEditingController();
  TextEditingController googleReviewController = TextEditingController();

  bool get isRentalActive => true;

  Timer? timer; // Declare a Timer variable
  int timeRemaining = 25; // Example: 60 seconds
  bool isRunning = false;

  void onChatTap() {
    _navigationService.navigateToInboxView();
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

  final List<OrderTrackingStep> _trackingSteps = [
    OrderTrackingStep(
      title: 'Rental Confirm',
      timestamp: '05:58 PM, 31 Jan 2025',
      isCompleted: true,
    ),
    OrderTrackingStep(
      title: 'Out for Delivery',
      timestamp: '05:58 PM, 31 Jan 2025',
      isCompleted: true,
    ),
    OrderTrackingStep(
      title: 'Delivery',
      timestamp: '05:58 PM, 31 Jan 2025',
      isCompleted: false,
    ),
  ];

  List<OrderTrackingStep> get trackingSteps => _trackingSteps;

  String getOrderId() {
    return '#1234567890';
  }

  String getEstimatedDeliveryTime() {
    return '30 minutes';
  }
}
