import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/stripe_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends BaseViewModel {
  final _stripeService = locator<StripeService>();
  final _apiService = locator<ApiService>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  TextEditingController teamNameController = TextEditingController();
  TextEditingController coachNameController = TextEditingController();
  TextEditingController fieldNumberController = TextEditingController();
  TextEditingController dropOffTimeController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  double totalAmount = 0;

  void calculateTotalAmount() {
    totalAmount = 0;
    totalAmount += items
        .map((item) => double.parse(item.price ?? '0') * item.quantity)
        .reduce((a, b) => a + b);
    if (bundles.isNotEmpty) {
      totalAmount += bundles
          .map((bundle) => double.parse(bundle.price ?? '0'))
          .reduce((a, b) => a + b);
    }

    print(totalAmount);
  }

  Future<void> pickDropOffDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: 0),
    );
    if (pickedTime == null) return;

    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Format as "YYYY-MM-DD HH:MM:SS"
    final String formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(combined);
    dropOffTimeController.text = formatted;
    notifyListeners();
  }

  bool isRentalSummaryExpanded = true;

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

  void toggleRentalSummaryExpanded() {
    isRentalSummaryExpanded = !isRentalSummaryExpanded;
    rebuildUi();
  }

  // Quantity controls for rental summary
  void incrementItemQuantity(ItemModel item) {
    final int index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;
    items[index].quantity = (items[index].quantity) + 1;
    calculateTotalAmount();
    notifyListeners();
  }

  void decrementItemQuantity(ItemModel item) {
    final int index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;
    final int current = items[index].quantity;
    items[index].quantity = current > 1 ? current - 1 : 1;
    calculateTotalAmount();
    notifyListeners();
  }

  void removeItemFromSummary(ItemModel item) {
    items.removeWhere((i) => i.id == item.id);
    calculateTotalAmount();
    notifyListeners();
  }

  void removeBundleFromSummary(BundleModel bundle) {
    bundles.removeWhere((i) => i.id == bundle.id);
    calculateTotalAmount();
    notifyListeners();
  }

  void toggleBundle(BundleModel bundle) {
    if (bundle.isSelected) {
      totalAmount += double.parse(bundle.price ?? '0');
    } else {
      totalAmount -= double.parse(bundle.price ?? '0');
    }
    bundle.isSelected = !bundle.isSelected;

    notifyListeners();
  }

  Future<void> _handleStripePayment(BuildContext context, num amount) async {
    logger.info('Stripe');
    final isPaymentSuccess = await _stripeService.payWithPaymentSheet(
      amount: amount,
      currency: 'usd',
      context: context,
    );

    if (isPaymentSuccess) {
      _navigationService.popUntil((route) => route.isFirst);
    }
  }

  // void _handleGooglePayPayment(BuildContext context) async {
  //   logger.info('Google Pay');
  //   // await _stripeService.payWithGooglePay(
  //   //   amountCents: 100,
  //   //   currency: 'usd',
  //   //   context: context,
  //   // );
  // }

  // void checkOut(BuildContext context) {
  //   _handleStripePayment(context, 10);
  //   // if (stripe) {
  //   //   _handleStripePayment(context);
  //   // } else if (googlePay) {
  //   //   _handleGooglePayPayment(context);
  //   // }
  // }

  Future<void> bookRental(BuildContext context) async {
    final url = ApiConfig.baseUrl + ApiConfig.bookRentalEndPoint;

    final body = {
      "tournament_id": tournamentId.toString(),
      "team_name": teamNameController.text,
      "coach_name": coachNameController.text,
      "field_number": fieldNumberController.text,
      "items": items
          .map((item) => {
                "item_id": item.id.toString(),
                "quantity": item.quantity,
              })
          .toList()
          .toString(),
      "bundles": bundles.map((bundle) => bundle.id).toList().toString(),
      "rental_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "drop_off_time": dropOffTimeController.text,
      "instructions": specialInstructionController.text,
      "promo_code": promoCodeController.text,
      "insurance_option": insuranceOne ? "3" : "7",
      "damage_waiver": damageWaiver.toString(),
      "payment_method": "stripe",
      "payment_status": "pending",
      "total_amount": totalAmount.toStringAsFixed(2),
    };

    print(body);

    try {
      final response = await _apiService.post(url, body);

      logger.info("Booking Rental Response: $response");

      await _handleStripePayment(context, totalAmount);
    } on ApiException catch (e) {
      _snackbarService.showCustomSnackBar(
          message: e.message,
          title: "Error",
          variant: SnackbarType.error,
          duration: const Duration(seconds: 3));
      logger.error("Error in booking rental: ${e.message}");
    } catch (e) {
      _snackbarService.showCustomSnackBar(
          message: "Something went wrong",
          title: "Error",
          variant: SnackbarType.error,
          duration: const Duration(seconds: 3));
      logger.error("Error in booking rental: ${e.toString()}");
    }
  }
}
