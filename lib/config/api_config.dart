import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const loginEndPoint = '/api/login';
  static const registerEndPoint = '/api/register';
  static const forgotPasswordEndPoint = '/api/password/reset';
  static const resetPasswordEndPoint = '/api/password/reset/confirm';
  static const verifyOtpEndPoint = '/api/email/verify-otp';
  static const verifyPasswordResetCodeEndPoint = '/api/verify-reset-code';
  static const validateReferralCodeEndPoint = '/api/validate/referral-code';
  static const googleSignInEndPoint = '/api/auth/google/login';

  static const meEndPoint = '/api/me';

  static const sportsEndPoint = '/api/sports';
  static const tournamentsBySportEndPoint = '/api/sports/tournaments';
  static const recommendedTournamentsEndPoint = '/api/tournaments';

  static const favoriteEndPoint = '/api/favorites';
  static const toggleFavoriteEndPoint = '/api/favorites/toggle';

  static const rentalHistoryEndPoint = '/api/rentals/user';
  // Add more as needed
}
