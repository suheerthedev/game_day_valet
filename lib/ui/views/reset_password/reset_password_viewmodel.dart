import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void onResetPassword() {
    logger.info("New Password: ${newPasswordController.text}");
    logger.info("Confirm Password: ${confirmPasswordController.text}");
    _navigationService.back();
    _navigationService.back();
  }
}
