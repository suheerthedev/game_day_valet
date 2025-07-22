import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void onResetPassword() {
    print(newPasswordController.text);
    print(confirmPasswordController.text);
    _navigationService.back();
    _navigationService.back();
  }
}
