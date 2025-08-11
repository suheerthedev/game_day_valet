import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
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
  bool applePay = false;
  bool googlePay = false;

  void toggleDropOffExpanded() {
    isDropOffExpanded = !isDropOffExpanded;
    rebuildUi();
  }

  void onStripePayment(BuildContext context) async {
    print('onStripePayment');
    await _stripeService.payWithPaymentSheet(
      amountCents: 1000,
      currency: 'usd',
      context: context,
    );
  }
}
