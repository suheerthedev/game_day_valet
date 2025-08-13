import 'package:game_day_valet/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:game_day_valet/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:game_day_valet/ui/views/home/home_view.dart';
import 'package:game_day_valet/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:game_day_valet/ui/views/onboarding/onboarding_view.dart';
import 'package:game_day_valet/ui/views/sign_up/sign_up_view.dart';
import 'package:game_day_valet/ui/views/sign_in/sign_in_view.dart';
import 'package:game_day_valet/ui/views/forgot_password/forgot_password_view.dart';
import 'package:game_day_valet/ui/views/reset_password/reset_password_view.dart';
import 'package:game_day_valet/ui/views/main/main_view.dart';
import 'package:game_day_valet/ui/views/rental_booking/rental_booking_view.dart';
import 'package:game_day_valet/ui/views/rental_status/rental_status_view.dart';
import 'package:game_day_valet/ui/views/profile/profile_view.dart';
import 'package:game_day_valet/ui/views/edit_profile/edit_profile_view.dart';
import 'package:game_day_valet/ui/views/rental_history/rental_history_view.dart';
import 'package:game_day_valet/ui/views/favorites/favorites_view.dart';
import 'package:game_day_valet/ui/views/privacy_policy/privacy_policy_view.dart';
import 'package:game_day_valet/ui/views/refer_and_earn/refer_and_earn_view.dart';
import 'package:game_day_valet/ui/views/faq/faq_view.dart';
import 'package:game_day_valet/ui/views/notification/notification_view.dart';
import 'package:game_day_valet/ui/views/chat/chat_view.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/auth_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:game_day_valet/ui/dialogs/success/success_dialog.dart';
import 'package:game_day_valet/ui/views/otp/otp_view.dart';
import 'package:game_day_valet/services/connectivity_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/google_sign_in_service.dart';
import 'package:game_day_valet/ui/views/verify_password_reset_code/verify_password_reset_code_view.dart';
import 'package:game_day_valet/ui/views/verify_email/verify_email_view.dart';
import 'package:game_day_valet/ui/views/add_rentals/add_rentals_view.dart';
import 'package:game_day_valet/ui/views/checkout/checkout_view.dart';
import 'package:game_day_valet/services/stripe_service.dart';
import 'package:game_day_valet/ui/views/search/search_view.dart';
import 'package:game_day_valet/ui/views/inbox/inbox_view.dart';
import 'package:game_day_valet/services/chat_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    CustomRoute(
      page: OnboardingView,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 1000,
      opaque: false,
      fullscreenDialog: true,
    ),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: SignInView),
    MaterialRoute(page: ForgotPasswordView),
    MaterialRoute(page: ResetPasswordView),
    MaterialRoute(page: MainView),
    MaterialRoute(page: RentalBookingView),
    MaterialRoute(page: RentalStatusView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: EditProfileView),
    MaterialRoute(page: RentalHistoryView),
    MaterialRoute(page: FavoritesView),
    MaterialRoute(page: PrivacyPolicyView),
    MaterialRoute(page: ReferAndEarnView),
    MaterialRoute(page: FaqView),
    MaterialRoute(page: NotificationView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: OtpView),
    MaterialRoute(page: VerifyPasswordResetCodeView),
    MaterialRoute(page: VerifyEmailView),
    MaterialRoute(page: AddRentalsView),
    MaterialRoute(page: CheckoutView),
    CustomRoute(
        page: SearchView,
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 500),
    MaterialRoute(page: InboxView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: SecureStorageService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: LoggerService),
    LazySingleton(classType: GoogleSignInService),
    LazySingleton(classType: StripeService),
    LazySingleton(classType: ChatService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: SuccessDialog),
// @stacked-dialog
  ],
)
class App {}
