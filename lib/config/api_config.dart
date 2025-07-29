import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const loginEndPoint = '/api/login';
  static const registerEndPoint = '/api/register';
  static const validateReferralCodeEndPoint = '/api/validate/referral-code';

  static const meEndPoint = '/api/me';
  // Add more as needed
}
