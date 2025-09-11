import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stacked_services/stacked_services.dart';

class AppleSignInService {
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();

  Future<dynamic> signIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      logger.info("Credentials: $credential");

      logger.info('Identity Token: ${credential.identityToken}');

      final idToken = credential.identityToken;

      if (idToken != null) {
        final response = await _authService.signInWithApple(
            idToken: credential.identityToken.toString());
        logger.info(response.toString());
        return response;
      } else {
        logger.error("❌ Google Sign-In Error: No ID Token");
      }
    } on SignInWithAppleException catch (e) {
      logger.error("Sign in with Apple Exception: ${e.toString()}");
    } on ApiException catch (e) {
      logger.error("Error in Apple Sign In: ${e.message}");
      _snackbarService.showCustomSnackBar(
          message: e.toString(), variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error in Apple Sign In: ${e.toString()}");
      _snackbarService.showCustomSnackBar(
          message: e.toString(), variant: SnackbarType.error);
    }
  }
}
