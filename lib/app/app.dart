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
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
