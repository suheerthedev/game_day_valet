import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/app/app.bottomsheets.dart';
import 'package:game_day_valet/app/app.dialogs.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
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
  await dotenv.load(fileName: ".env");
  await setupLocator();

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
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
