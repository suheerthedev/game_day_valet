import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

class StripeService {
  final _snackbarService = locator<SnackbarService>();
  final _apiService = locator<ApiService>();

  Future<bool> payWithPaymentSheet(
      {required num amount,
      String currency = 'usd',
      required BuildContext context}) async {
    final url = ApiConfig.baseUrl + ApiConfig.createPaymentIntent;

    try {
      final response = await _apiService.post(url, {
        'amount': amount,
        'currency': currency,
      });

      logger.info('Payment intent created: $response');

      final clientSecret = response['clientSecret'] as String;

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Game Day Valet',
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          testEnv: true,
          buttonType: PlatformButtonType.buy,
        ),
        appearance: const PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            icon: AppColors.primary,
            primary: AppColors.secondary,
            background: AppColors.white,
            componentBackground: AppColors.grey100,
            primaryText: AppColors.primary,
            placeholderText: AppColors.textHint,
            componentText: AppColors.primary,
            secondaryText: AppColors.primary,
            componentBorder: AppColors.grey300,
            componentDivider: AppColors.grey300,
          ),
          shapes: PaymentSheetShape(
            borderRadius: 12,
            shadow: PaymentSheetShadowParams(
              color: Colors.black26,
            ),
          ),
          primaryButton: PaymentSheetPrimaryButtonAppearance(
            colors: PaymentSheetPrimaryButtonTheme(
              light: PaymentSheetPrimaryButtonThemeColors(
                background: AppColors.secondary,
                text: AppColors.white,
              ),
              dark: PaymentSheetPrimaryButtonThemeColors(
                background: AppColors.secondary,
                text: AppColors.white,
              ),
            ),
          ),
        ),
      ));

      await Stripe.instance.presentPaymentSheet();

      _snackbarService.showCustomSnackBar(
        message: 'Payment successful!',
        variant: SnackbarType.success,
      );

      return true;
    } on StripeException catch (e) {
      _snackbarService.showCustomSnackBar(
        message: e.error.localizedMessage ?? 'Payment failed!',
        variant: SnackbarType.error,
      );
      return false;
    } on ApiException catch (e) {
      _snackbarService.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
      );
      return false;
    } catch (e) {
      _snackbarService.showCustomSnackBar(
        message: 'Payment failed!',
        variant: SnackbarType.error,
      );
      return false;
    }
  }
}
