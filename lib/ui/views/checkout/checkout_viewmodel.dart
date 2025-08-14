import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/stripe_service.dart';
import 'package:stacked/stacked.dart';

class CheckoutViewModel extends BaseViewModel {
  final _stripeService = locator<StripeService>();

  TextEditingController teamNameController = TextEditingController();
  TextEditingController coachNameController = TextEditingController();
  TextEditingController ageGroupController = TextEditingController();
  TextEditingController dropOffTimeController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  bool isDropOffExpanded = false;

  bool insuranceOne = false;
  bool insuranceTwo = false;
  bool damageWaiver = false;
  bool stripe = false;
  // bool applePay = false;
  bool googlePay = false;

  List<ItemModel> items = [];
  List<BundleModel> bundles = [];
  CheckoutViewModel({required this.items, required this.bundles});

  void toggleDropOffExpanded() {
    isDropOffExpanded = !isDropOffExpanded;
    rebuildUi();
  }

  void _handleStripePayment(BuildContext context) async {
    logger.info('Stripe');
    await _stripeService.payWithPaymentSheet(
      amount: 10,
      currency: 'usd',
      context: context,
    );
  }

  void _handleGooglePayPayment(BuildContext context) async {
    logger.info('Google Pay');
    // await _stripeService.payWithGooglePay(
    //   amountCents: 100,
    //   currency: 'usd',
    //   context: context,
    // );
  }

  void checkOut(BuildContext context) {
    if (stripe) {
      _handleStripePayment(context);
    } else if (googlePay) {
      _handleGooglePayPayment(context);
    }
  }
}
