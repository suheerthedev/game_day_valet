import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
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

      return response;
    } on ApiException catch (_) {
      rethrow;
    } catch (_) {
      throw ApiException("Login Failed.");
    }
  }

  Future<dynamic> register(Map<String, dynamic> body) async {
    final url = ApiConfig.baseUrl + ApiConfig.registerEndPoint;

    try {
      final response = await _apiService.post(url, body);
      return response;
    } on ApiException catch (e) {
      print("Api Exception: $e");
      rethrow;
    } catch (e) {
      throw ApiException("Registration Failed. $e");
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    final url = ApiConfig.baseUrl + ApiConfig.forgotPasswordEndPoint;

    try {
      final response = await _apiService.post(url, {'email': email});
      return response;
    } on ApiException catch (e) {
      print("Api Exception: $e");
      rethrow;
    } catch (e) {
      throw ApiException("Forgot Password Failed. $e");
    }
  }

  Future<dynamic> validateReferralCode(String referralCode) async {
    final url = ApiConfig.baseUrl + ApiConfig.validateReferralCodeEndPoint;

    try {
      final response =
          await _apiService.post(url, {'referral_code': referralCode});
      return response;
    } on ApiException catch (e) {
      print("Api Exception: $e");
      rethrow;
    } catch (e) {
      throw ApiException("Referral Code Validation Failed. $e");
    }
  }
}
