import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.dialogs.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/services/api_exception.dart';
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
  final TextEditingController referralCodeController = TextEditingController();

  String? emailError;
  String? nameError;
  String? passwordError;
  String? referralCodeError;

  String? generalError;

  bool isPasswordVisible = false;

  bool isReferralCodeValid = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }

  void clearAllErrors() {
    emailError = null;
    nameError = null;
    passwordError = null;
    generalError = null;
    referralCodeError = null;
  }

  void clearControllers() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    referralCodeController.clear();
    isReferralCodeValid = false;
  }

  void validateReferralCode() async {
    referralCodeError = null;
    setBusy(true);
    try {
      final response =
          await _authService.validateReferralCode(referralCodeController.text);
      print("Validate Referral Code Response: $response");

      if (response.containsKey('errors')) {
        referralCodeError = response['errors']['referral_code'][0];
      }

      if (response['is_valid'] == true) {
        isReferralCodeValid = true;
      } else {
        isReferralCodeValid = false;
      }
    } catch (e) {
      if (e is ApiException) {
        referralCodeError = e.message;
      }
      print(e);
    } finally {
      setBusy(false);
    }
  }

  void onSignUp() async {
    if (!isReferralCodeValid && referralCodeController.text.isNotEmpty) {
      referralCodeError = "Verify your referral code first. Click Apply";
      rebuildUi();
      return;
    }
    clearAllErrors();
    setBusy(true);
    try {
      final body = {
        'email': emailController.text,
        'name': nameController.text,
        'password': passwordController.text,
        if (referralCodeController.text.isNotEmpty)
          'referral_code': referralCodeController.text,
      };
      print("Register Body: $body");

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
      if (e is ApiException) {
        generalError = e.message;
      }
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
