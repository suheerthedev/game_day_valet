import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController emailController = TextEditingController();

  void onForgotPassword() {
    print(emailController.text);
    _navigationService.navigateToResetPasswordView();
  }
}
