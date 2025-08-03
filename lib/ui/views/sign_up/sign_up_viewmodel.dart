import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/google_sign_in_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();
  final _googleSignInService = locator<GoogleSignInService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _userService = locator<UserService>();

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
      logger.info("Validate Referral Code Response: $response");

      if (response.containsKey('errors')) {
        referralCodeError = response['errors']['referral_code'][0];
      }

      if (response['is_valid'] == true) {
        isReferralCodeValid = true;
      } else {
        isReferralCodeValid = false;
      }
    } on ApiException catch (e) {
      logger.error(
          "Validate Referral Code failed from ViewModel - API Exception", e);
      referralCodeError = e.message;
    } catch (e) {
      logger.error(
          "Validate Referral Code failed from ViewModel - Unknown error", e);
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
      logger.info("Register Body: $body");

      final response = await _authService.register(body);

      if (response.containsKey('errors')) {
        if (response['message'] != null) {
          _snackbarService.showCustomSnackBar(
            variant: SnackbarType.error,
            message: response['message'],
          );
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
        await _snackbarService.showCustomSnackBar(
          variant: SnackbarType.success,
          message: response['message'],
        );
        await _navigationService.navigateToOtpView(email: emailController.text);

        clearControllers();
      }
      logger.info("Name Error: $nameError");
      logger.info("Email Error: $emailError");
      logger.info("Password Error: $passwordError");

      logger.info("Register Response: $response");
    } on ApiException catch (e) {
      logger.error("Register failed from ViewModel - API Exception", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Register failed from ViewModel - Unknown error", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  void onGoogleSignUp() async {
    try {
      final response = await _googleSignInService.signIn();

      if (response != null) {
        if (response.containsKey('errors')) {
          if (response['message'] != null) {
            _snackbarService.showCustomSnackBar(
              variant: SnackbarType.error,
              message: response['message'],
            );
          }
        } else {
          setBusy(true);
          await _snackbarService.showCustomSnackBar(
            variant: SnackbarType.success,
            title: 'Success',
            message: response['message'],
            duration: const Duration(seconds: 3),
          );

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
        }
      }

      logger.info("Google Sign In Response: $response");
    } on ApiException catch (e) {
      logger.error("Google Sign In failed from ViewModel - API Exception", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Google Sign In failed from ViewModel - Unknown error", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      setBusy(false);
      rebuildUi();
    }
  }

  void onAppleSignUp() {
    logger.info("Apple Sign Up");
  }

  void goToSignIn() {
    _navigationService.navigateToSignInView();
  }
}
