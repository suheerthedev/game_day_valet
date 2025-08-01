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
        await _snackbarService.showCustomSnackBar(
          variant: SnackbarType.error,
          message: response['message'],
        );
        if (response['errors'].containsKey('email')) {
          emailError = response['errors']['email'][0];
        }
      } else {
        await _snackbarService.showCustomSnackBar(
            message: response['message'], variant: SnackbarType.success);

        await _navigationService.navigateToOtpView(email: emailController.text);
        clearController();
      }

      // _navigationService.navigateToOtpView(email: emailController.text);
      // clearController();
    } on ApiException catch (e) {
      logger.error("Forgot Password failed from ViewModel - API Exception", e);
    } catch (e) {
      logger.error("Forgot Password failed from ViewModel - Unknown error", e);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
