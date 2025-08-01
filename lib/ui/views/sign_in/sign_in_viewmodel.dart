import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignInViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _userService = locator<UserService>();
  final _snackbarService = locator<SnackbarService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  String? generalError;

  bool isRememberMe = false;
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }

  clearAllErrors() {
    emailError = null;
    passwordError = null;
    generalError = null;
  }

  clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void onSignIn() async {
    clearAllErrors();
    setBusy(true);

    try {
      final response = await _authService.login(
          email: emailController.text, password: passwordController.text);

      logger.info("Login Response: $response");

      if (response.containsKey('errors')) {
        if (response['message'] != null) {
          if (response['message'] ==
              'Your email is not verified. A new OTP has been sent.') {
            await _snackbarService.showCustomSnackBar(
              variant: SnackbarType.error,
              message: response['message'],
            );
            await _navigationService.navigateToOtpView(
                email: emailController.text);
          } else {
            _snackbarService.showCustomSnackBar(
              variant: SnackbarType.error,
              message: response['message'],
            );
          }
        }

        if (response['errors'].containsKey('email')) {
          emailError = response['errors']['email'][0];
        }
        if (response['errors'].containsKey('password')) {
          passwordError = response['errors']['password'][0];
        }
      } else {
        if (!response.containsKey('token')) {
          throw ApiException("Token not found in response", 500);
        }

        final tokenParts = response['token'].split('|');
        if (tokenParts.length != 2) {
          throw ApiException("Invalid token format", 500);
        }

        final token = tokenParts[1];
        await _secureStorageService.saveToken(token);

        await _userService.fetchCurrentUser();

        await _navigationService.clearStackAndShow(Routes.mainView);
        setBusy(false);
      }
    } on ApiException catch (e) {
      logger.error("Login failed from ViewModel - API Exception", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Login failed from ViewModel - Unknown error", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void onGoogleSignIn() {
    logger.info("Google Sign In");
  }

  void onAppleSignIn() {
    logger.info("Apple Sign In");
  }

  void goToSignUp() {
    _navigationService.back();
  }

  void goToForgotPassword() {
    _navigationService.navigateToForgotPasswordView();
  }
}
