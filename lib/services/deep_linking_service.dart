import 'package:app_links/app_links.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:game_day_valet/services/startup_service.dart';
import 'package:stacked_services/stacked_services.dart';

class DeepLinkingService {
  final _appLinks = AppLinks();
  final _navigationService = locator<NavigationService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _snackbarService = locator<SnackbarService>();
  final _startupService = locator<StartupService>();

  bool isStartupInitiated = false;

  static Uri? pendingUri;

  String? pendingRoute;

  static String? referralCode;

  void init() {
    _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });

    _getInitialUri();
  }

  Future<void> _getInitialUri() async {
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        logger.info('Initial URI Recieved: $initialUri');
        pendingUri = initialUri;
      }
    } catch (e) {
      logger.error("Error getting initial URI: $e");
    }
  }

  Future<bool> processPendingUri() async {
    if (pendingUri != null) {
      logger.info('Processing pending URI: $pendingUri');
      await _handleUri(pendingUri!);

      pendingUri = null;
      return true;
    }
    return false;
  }

  Future<void> _handleUri(Uri uri) async {
    final path = uri.path;
    logger.info('Handling deep link: $uri with path: $path');

    final queryParams = uri.queryParameters;

    if (path == '/register-referral') {
      referralCode = queryParams['referralCode'];
      logger.info('Referral code: $referralCode');
      logger.info('Is startup initiated: $isStartupInitiated');
      if (isStartupInitiated) {
        logger.info('Has token: ${await _secureStorageService.hasToken()}');
        if (await _secureStorageService.hasToken()) {
          _snackbarService.showCustomSnackBar(
            message:
                'You are already logged in. Logout to use the referral code.',
            variant: SnackbarType.warning,
            duration: const Duration(seconds: 3),
          );
          if (await _startupService.validateToken()) {
            await _startupService.runTokenTasks();
            await _navigationService.replaceWithMainView();
          }
        } else {
          _navigationService.clearStackAndShow(Routes.signUpView,
              arguments: SignUpViewArguments(
                referralCode: referralCode,
              ));
          clearAll();
        }
      } else {
        pendingRoute = Routes.signUpView;
      }
    }
  }

  String? getReferralCode() => referralCode;

  String? getPendingRoute() => pendingRoute;

  void clearAll() {
    pendingUri = null;
    pendingRoute = null;
    referralCode = null;
  }

  void clearReferralCode() {
    referralCode = null;
  }

  void clearPendingRoute() {
    pendingRoute = null;
  }
}
