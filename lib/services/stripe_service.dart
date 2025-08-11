import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:stacked_services/stacked_services.dart';

class StripeService {
  final _snackbarService = locator<SnackbarService>();
  Future<void> payWithPaymentSheet(
      {required int amountCents,
      String currency = 'usd',
      required BuildContext context}) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: dotenv.env['STRIPE_CLIENT_SECRET_KEY'] ?? '',
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
