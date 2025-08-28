import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const loginEndPoint = '/api/login';
  static const registerEndPoint = '/api/register';
  static const forgotPasswordEndPoint = '/api/password/reset';
  static const resetPasswordEndPoint = '/api/reset-password';
  static const verifyOtpEndPoint = '/api/email/verify-otp';
  static const verifyPasswordResetCodeEndPoint = '/api/verify-reset-code';
  static const validateReferralCodeEndPoint = '/api/validate/referral-code';
  static const googleSignInEndPoint = '/api/auth/google/login';

  static const meEndPoint = '/api/me';
  static const profileEndPoint = '/api/profile';

  static const sportsEndPoint = '/api/sports';
  static const tournamentsBySportEndPoint = '/api/sports/tournaments';
  static const tournamentsEndPoint = '/api/tournaments';

  static const favoriteEndPoint = '/api/favorites';
  static const toggleFavoriteEndPoint = '/api/favorites/toggle';

  static const rentalHistoryEndPoint = '/api/rentals/user';

  static const privacyPolicyEndPoint = '/api/privacy-policies';
  static const termsAndConditionsEndPoint = '/api/terms-and-conditions';

  static const faqsEndPoint = '/api/faqs';

  static const items = '/api/items';
  static const bundles = '/api/bundles';

  //Payment
  static const createPaymentIntent = '/api/create-payment-intent';

  //Chat
  static const conversationsEndPoint = '/api/chat/conversations';
  static const conversationMessagesEndPoint =
      '/api/chat/conversations/messages';
  static const sendMessageEndPoint = '/api/chat/send';
  static const markMessageAsReadEndPoint = '/api/chat/conversations/mark-read';
  // Rental
  static const rentalEndPoint = '/api/rentals';
  static const rentalStatusEndPoint = '/api/rentals/status';
  static const applyPromoCodeEndPoint = '/api/coupon/validate';
  static const settingsItemsEndPoint = '/api/settings/booking';
  //Refer and Earn
  static const referralCodeEndPoint = '/api/user/referral-code';

  static const toggleNotificationsEndPoint = '/api/notifications/fcm/toggle';
  static const notificationsEndPoint = '/api/notifications';

  static const initalChatMessageEndPoint = '/api/settings/chat';

  // Add more as needed
}
