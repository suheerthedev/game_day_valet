import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isRememberMe = false;

  void onSignIn() {
    print(emailController.text);
    print(passwordController.text);
    _navigationService.navigateToMainView();
  }

  void onGoogleSignIn() {
    print("Google Sign In");
  }

  void onAppleSignIn() {
    print("Apple Sign In");
  }

  void goToSignUp() {
    _navigationService.back();
  }

  void goToForgotPassword() {
    _navigationService.navigateToForgotPasswordView();
  }
}
