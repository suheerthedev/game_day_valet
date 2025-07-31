import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OtpViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  final TextEditingController otpController = TextEditingController();

  bool isDisabled = true;

  void validateOtp(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      isDisabled = true;
      rebuildUi();
    } else {
      isDisabled = false;
      rebuildUi();
    }
  }

  void onVerifyOtp(String email, String otp) async {
    setBusy(true);
    try {
      final response = await _authService.verifyOtp(email, otp);

      print("Response: $response");

      if (response['message'] == 'Invalid or expired OTP.') {
        _snackbarService.showCustomSnackBar(
          variant: SnackbarType.error,
          message: response['message'],
        );
        return;
      }

      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        message: response['message'],
      );

      _navigationService.replaceWithSignInView();
    } on ApiException catch (e) {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      setBusy(false);
      rebuildUi();
    }
  }
}
