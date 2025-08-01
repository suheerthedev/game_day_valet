import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final _authService = locator<AuthService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<dynamic> signIn() async {
    logger.info("🔄 Google Sign In Called");

    try {
      // ✅ 1. Initialize the GoogleSignIn instance
      await _googleSignIn.initialize(
          serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '');

      // ✅ 2. Authenticate (shows Google sign-in dialog)
      final account = await _googleSignIn.authenticate();

      // if (account == null) {
      //   logger.wtf("⚠️ User canceled sign-in");
      //   return;
      // }

      // ✅ 3. Get the ID token (used for backend auth if needed)
      final accountName = account.displayName;
      final accountEmail = account.email;
      final auth = account.authentication;
      final idToken = auth.idToken;

      logger.info("✅ Signed in user:");
      logger.info("Name: $accountName");
      logger.info("Email: $accountEmail");
      logger.info("ID Token: $idToken");

      if (idToken != null) {
        final response = await _authService.signInWithGoogle(idToken: idToken);
        return response;
      } else {
        logger.error("❌ Google Sign-In Error: No ID Token");
      }

      // You can now send idToken to Laravel backend if needed
    } catch (e) {
      logger.error("❌ Google Sign-In Error: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    logger.info("👋 User signed out");
  }
}
