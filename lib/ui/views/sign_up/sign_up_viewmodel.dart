import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onSignUp() {
    print(emailController.text);
    print(nameController.text);
    print(passwordController.text);
    _navigationService.navigateToHomeView();
  }

  void onGoogleSignUp() {
    print("Google Sign Up");
  }

  void onAppleSignUp() {
    print("Apple Sign Up");
  }

  void goToSignIn() {
    _navigationService.navigateToSignInView();
  }
}
