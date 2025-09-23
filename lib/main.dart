import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game_day_valet/app/app.bottomsheets.dart';
import 'package:game_day_valet/app/app.dialogs.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/firebase_options.dart';
import 'package:game_day_valet/services/deep_linking_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/push_notification_service.dart';
// import 'package:game_day_valet/services/connectivity_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/snackbars/error/error_snackbar.dart';
import 'package:game_day_valet/ui/snackbars/info/info_snackbar.dart';
import 'package:game_day_valet/ui/snackbars/no_internet/no_internet_snackbar.dart';
import 'package:game_day_valet/ui/snackbars/success/success_snackbar.dart';
import 'package:game_day_valet/ui/snackbars/warning/warning_snackbar.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize deep linking service

  logger.intialize(isProduction: kReleaseMode);

  await dotenv.load(fileName: ".env");
  await setupLocator();

  locator<DeepLinkingService>().init();

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // await locator<ConnectivityService>().initialize();

  // Register snackbar configs
  locator<SnackbarService>().registerCustomSnackbarConfig(
    variant: SnackbarType.success,
    config: getSuccessSnackbarConfig(),
  );

  locator<SnackbarService>().registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: getErrorSnackbarConfig(),
  );

  locator<SnackbarService>().registerCustomSnackbarConfig(
    variant: SnackbarType.warning,
    config: getWarningSnackbarConfig(),
  );

  locator<SnackbarService>().registerCustomSnackbarConfig(
    variant: SnackbarType.info,
    config: getInfoSnackbarConfig(),
  );

  locator<SnackbarService>().registerCustomSnackbarConfig(
    variant: SnackbarType.noInternet,
    config: getNoInternetSnackbarConfig(),
  );

  setupDialogUi();
  setupBottomSheetUi();

  await Stripe.instance.applySettings();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locator<PushNotificationService>().init(context);
    });
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondary),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.startupView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [StackedService.routeObserver],
      ),
    );
  }
}
