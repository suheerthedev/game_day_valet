import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  final TextEditingController emailController = TextEditingController();

  String? emailError;
  String? generalError;

  void clearAllErrors() {
    emailError = null;
    generalError = null;
  }

  void clearController() {
    emailController.clear();
  }

  Future<void> onForgotPassword() async {
    clearAllErrors();
    setBusy(true);
    try {
      final response = await _authService.forgotPassword(emailController.text);
      logger.info("Forgot Password Response: $response");

      if (response.containsKey('errors')) {
        if (response['message'] != null) {
          generalError = response['message'];
        }
        if (response['errors'].containsKey('email')) {
          emailError = response['errors']['email'][0];
        }
      } else {
        _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);

        clearController();

        _navigationService.navigateToOtpView(email: emailController.text);
      }

      _navigationService.navigateToOtpView(email: emailController.text);
      clearController();
    } catch (e) {
      if (e is ApiException) {
        logger.error(
            "Forgot Password failed from ViewModel - API Exception", e);
      } else {
        logger.error(
            "Forgot Password failed from ViewModel - Unknown error", e);
      }
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
