import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
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

  double totalAmount = 0;

  bool isDropOffExpanded = false;
  bool isRentalSummaryExpanded = false;

  bool insuranceOne = false;
  bool insuranceTwo = false;
  bool damageWaiver = false;
  bool stripe = false;
  // bool applePay = false;
  // bool googlePay = false;

  final int tournamentId;
  List<ItemModel> items = [];
  List<BundleModel> bundles = [];
  CheckoutViewModel(
      {required this.items, required this.bundles, required this.tournamentId});

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
    _handleStripePayment(context);
    // if (stripe) {
    //   _handleStripePayment(context);
    // } else if (googlePay) {
    //   _handleGooglePayPayment(context);
    // }
  }

  Future<void> bookRental() async {
    final url = ApiConfig.baseUrl + ApiConfig.bookRentalEndPoint;

    final body = {
      "tournament_id": tournamentId,
      "team_name": teamNameController.text,
      "coach_name": coachNameController.text,
      "field_number": fieldNumberController.text,
      "items": items
          .map((item) => {
                "id": item.id,
                "quantity": item.quantity,
              })
          .toList(),
      "bundles": bundles
          .map((bundle) => {
                "id": bundle.id,
              })
          .toList(),
      // "rental_date": "Date here",
      "drop_off_time": dropOffTimeController.text,
      "instructions": specialInstructionController.text,
      "promo_code": promoCodeController.text,
      // "insurance_option": ,
      "damage_waiver": damageWaiver,
      "payment_method": "stripe",
      "total_amount": totalAmount,
    };

    try {
      // final response = await http.post(Uri.parse(url), body: body);
    } on ApiException catch (e) {
      logger.error(e.message);
    } catch (e) {
      logger.error(e.toString());
    }
  }
}
