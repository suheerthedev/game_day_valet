import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
// import 'package:game_day_valet/services/user_service.dart';

class AuthService {
  final _apiService = locator<ApiService>();
  // final _userService = locator<UserService>();

  Future<dynamic> login(
      {required String email, required String password}) async {
    final url = ApiConfig.baseUrl + ApiConfig.loginEndPoint;

    try {
      final response =
          await _apiService.post(url, {'email': email, 'password': password});

      logger.info("Login successful for email: $email");
      return response;
    } on ApiException catch (e) {
      logger.error("Login failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("Login failed - Unknown error", e);
      throw ApiException("Login Failed.");
    }
  }

  Future<dynamic> register(Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.registerEndPoint;

    try {
      final response = await _apiService.post(url, body);

      logger.info("Registration successful for email: ${body['email']}");
      return response;
    } on ApiException catch (e) {
      logger.error("Registration failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("Registration failed - Unknown error", e);
      throw ApiException("Registration Failed. $e");
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    final url = ApiConfig.baseUrl + ApiConfig.forgotPasswordEndPoint;

    try {
      final response = await _apiService.post(url, {'email': email});

      logger.info("Forgot Password successful for email: $email");
      return response;
    } on ApiException catch (e) {
      logger.error("Forgot Password failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("Forgot Password failed - Unknown error", e);
      throw ApiException("Forgot Password Failed. $e");
    }
  }

  Future<dynamic> validateReferralCode(String referralCode) async {
    final url = ApiConfig.baseUrl + ApiConfig.validateReferralCodeEndPoint;

    try {
      final response =
          await _apiService.post(url, {'referral_code': referralCode});

      logger
          .info("Referral Code Validation successful for code: $referralCode");
      return response;
    } on ApiException catch (e) {
      logger.error("Referral Code Validation failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("Referral Code Validation failed - Unknown error", e);
      throw ApiException("Referral Code Validation Failed. $e");
    }
  }

  Future<dynamic> verifyOtp(String email, String otp) async {
    final url = ApiConfig.baseUrl + ApiConfig.verifyOtpEndPoint;

    try {
      final response =
          await _apiService.post(url, {'email': email, 'otp': otp});

      logger.info("OTP Verification successful for email: $email");
      return response;
    } on ApiException catch (e) {
      logger.error("OTP Verification failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("OTP Verification failed - Unknown error", e);
      throw ApiException("OTP Verification Failed. $e");
    }
  }

  Future<dynamic> signInWithGoogle({required String idToken}) async {
    final url = ApiConfig.baseUrl + ApiConfig.googleSignInEndPoint;

    try {
      final response = await _apiService.post(url, {
        'id_token': idToken,
      });

      logger.info("Google Sign In successful for idToken: $idToken");
      logger.info("Google Sign In Response: $response");
      return response;
    } on ApiException catch (e) {
      logger.error("Google Sign In failed - API Exception", e);
      rethrow;
    } catch (e) {
      logger.error("Google Sign In failed - Unknown error", e);
      throw ApiException("Google Sign In Failed. $e");
    }
  }
}
