import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StripeService {
  final _snackbarService = locator<SnackbarService>();
  final _apiService = locator<ApiService>();

  Future<void> payWithPaymentSheet(
      {required int amountCents,
      String currency = 'usd',
      required BuildContext context}) async {
    final url = ApiConfig.baseUrl + ApiConfig.createPaymentIntent;
    try {
      final response = await _apiService.post(url, {
        'amount': amountCents,
        'currency': currency,
      });

      logger.info('Payment intent created: $response');

      final clientSecret = response['clientSecret'] as String;

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Game Day Valet',
      ));

      await Stripe.instance.presentPaymentSheet();

      _snackbarService.showCustomSnackBar(
        message: 'Payment successful!',
        variant: SnackbarType.success,
      );
    } catch (e) {
      _snackbarService.showCustomSnackBar(
        message: 'Payment failed!',
        variant: SnackbarType.error,
      );
    }
  }
}
