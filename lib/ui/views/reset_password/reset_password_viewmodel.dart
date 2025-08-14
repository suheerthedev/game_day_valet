import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ResetPasswordViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    rebuildUi();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    rebuildUi();
  }

  final String email;
  final String code;
  ResetPasswordViewModel({required this.email, required this.code});

  bool validateForm() {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _snackbarService.showCustomSnackBar(
          message: "New Password and Confirm Password are required",
          variant: SnackbarType.error);
      return false;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _snackbarService.showCustomSnackBar(
          message: "New Password and Confirm Password do not match",
          variant: SnackbarType.error);
      return false;
    }
    return true;
  }

  clearControllers() {
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> onResetPassword() async {
    if (!validateForm()) return;

    setBusy(true);

    try {
      final response = await _authService.resetPassword(
          email, code, passwordController.text);

      logger.info("Reset Password Response: $response");

      if (response.containsKey('errors')) {
        _snackbarService.showCustomSnackBar(
          message: response['message'],
          variant: SnackbarType.error,
        );
      } else {
        _navigationService
            .popUntil((route) => route.settings.name == Routes.signInView);
        await _snackbarService.showCustomSnackBar(
          message: response['message'],
          variant: SnackbarType.success,
        );
        setBusy(false);
        clearControllers();
      }
    } on ApiException catch (e) {
      logger.error("Reset Password failed from ViewModel - API Exception", e);
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
    } catch (e) {
      logger.error("Reset Password failed from ViewModel - Unknown error", e);
      _snackbarService.showCustomSnackBar(
        message: e.toString(),
        variant: SnackbarType.error,
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }
}
