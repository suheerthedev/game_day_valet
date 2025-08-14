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
  TextEditingController fieldNumberController = TextEditingController();
  TextEditingController dropOffTimeController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  bool isDropOffExpanded = false;
  bool isRentalSummaryExpanded = false;

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

  void toggleRentalSummaryExpanded() {
    isRentalSummaryExpanded = !isRentalSummaryExpanded;
    rebuildUi();
  }

  // Quantity controls for rental summary
  void incrementItemQuantity(ItemModel item) {
    final int index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;
    items[index].quantity = (items[index].quantity) + 1;
    notifyListeners();
  }

  void decrementItemQuantity(ItemModel item) {
    final int index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;
    final int current = items[index].quantity;
    items[index].quantity = current > 1 ? current - 1 : 1;
    notifyListeners();
  }

  void removeItemFromSummary(ItemModel item) {
    items.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }

  void removeBundleFromSummary(BundleModel bundle) {
    bundles.removeWhere((i) => i.id == bundle.id);
    notifyListeners();
  }

  void toggleBundle(BundleModel bundle) {
    bundle.isSelected = !bundle.isSelected;
    notifyListeners();
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
