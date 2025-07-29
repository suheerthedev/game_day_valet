import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.dialogs.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? nameError;
  String? passwordError;

  String? generalError;

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }

  void clearErrors() {
    emailError = null;
    nameError = null;
    passwordError = null;
    generalError = null;
  }

  void clearControllers() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
  }

  void onSignUp() async {
    clearErrors();
    setBusy(true);
    try {
      final body = {
        'email': emailController.text,
        'name': nameController.text,
        'password': passwordController.text,
      };
      print("Body: $body");

      final response = await _authService.register(body);

      if (response.containsKey('errors')) {
        if (response['message'] != null) {
          generalError = response['message'];
        }
        if (response['errors'].containsKey('email')) {
          emailError = response['errors']['email'][0];
        }
        if (response['errors'].containsKey('name')) {
          nameError = response['errors']['name'][0];
        }
        if (response['errors'].containsKey('password')) {
          passwordError = response['errors']['password'][0];
        }
      } else {
        clearControllers();
        setBusy(false);
        _dialogService.showCustomDialog(
          variant: DialogType.success,
          title: "Success",
          description: response['message'],
          mainButtonTitle: "Got it",
        );
      }
      print("Name Error: $nameError");
      print("Email Error: $emailError");
      print("Password Error: $passwordError");

      print(response);
    } catch (e) {
      print(e);
    } finally {
      rebuildUi();
      setBusy(false);
    }
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
