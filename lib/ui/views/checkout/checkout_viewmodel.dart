import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/coupon_model.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/rental_service.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckoutViewModel extends BaseViewModel {
  final _snackbarService = locator<SnackbarService>();
  final _rentalService = locator<RentalService>();
  final _userService = locator<UserService>();

  UserModel? get user => _userService.currentUser;

  TextEditingController teamNameController = TextEditingController();
  TextEditingController coachNameController = TextEditingController();
  TextEditingController fieldNumberController = TextEditingController();
  TextEditingController dropOffTimeController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  String teamNameError = '';
  String coachNameError = '';
  String fieldNumberError = '';

  bool validateForm() {
    bool isValid = true;
    if (teamNameController.text.isEmpty) {
      isValid = false;
      teamNameError = 'Team name is required';
    }
    if (coachNameController.text.isEmpty) {
      isValid = false;
      coachNameError = 'Coach name is required';
    }
    if (fieldNumberController.text.isEmpty) {
      isValid = false;
      fieldNumberError = 'Field number is required';
    }
    rebuildUi();
    return isValid;
  }

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

  bool isLoading = false;

  bool insuranceOne = false;
  bool insuranceTwo = false;
  bool damageWaiver = false;
  bool stripe = false;
  bool isPromoCodeValid = false;
  String? promoCodeError;

  CouponModel? coupon;

  void validatePromoCode() async {
    if (promoCodeController.text.isEmpty) {
      promoCodeError = 'Promo code is required';
      rebuildUi();
      return;
    }
    removeDiscount();
    isPromoCodeValid = false;
    promoCodeError = null;
    coupon = null;

    setBusy(true);
    rebuildUi();
    try {
      final response =
          await _rentalService.applyPromoCode(promoCodeController.text, {
        "user_id": user!.id.toString(),
        "promo_code": promoCodeController.text,
      });

      if (response.containsKey('errors')) {
        promoCodeError = response['errors']['promo_code'][0];
      } else {
        isPromoCodeValid = true;
        promoCodeError = null;
        coupon = CouponModel.fromJson(response['data']['coupon']);
        applyDiscount();
      }
    } catch (e) {
      promoCodeError = "Something went wrong";
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

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

  List<Map<String, dynamic>> formatItems(List<ItemModel> items) {
    return items
        .where((item) => item.quantity > 0)
        .map((item) =>
            {"item_id": item.id.toString(), "quantity": item.quantity})
        .toList();
  }

  List<int> formatBundles(List<BundleModel> bundles) {
    return bundles
        .where((bundle) => bundle.isSelected)
        .map((bundle) => bundle.id)
        .toList();
  }

  void applyDiscount() {
    if (isPromoCodeValid) {
      if (coupon?.type == "fixed") {
        totalAmount = totalAmount - double.parse(coupon?.value ?? '0');
      }

      if (coupon?.type == "percent") {
        totalAmount =
            totalAmount * (1 - (double.parse(coupon?.value ?? '0') / 100));
      }
    }
  }

  void removeDiscount() {
    if (isPromoCodeValid) {
      if (coupon?.type == "fixed") {
        totalAmount = totalAmount + double.parse(coupon?.value ?? '0');
      }
    }

    if (coupon?.type == "percent") {
      totalAmount =
          totalAmount * (1 + (double.parse(coupon?.value ?? '0') / 100));
    }

    notifyListeners();
  }

  Future<void> bookRental(BuildContext context) async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading = true;
      rebuildUi();
      await _rentalService.createRentalBooking(context, totalAmount, {
        "tournament_id": tournamentId.toString(),
        "team_name": teamNameController.text,
        "coach_name": coachNameController.text,
        "field_number": fieldNumberController.text,
        "items": formatItems(items),
        "bundles": formatBundles(bundles),
        "rental_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "drop_off_time": dropOffTimeController.text,
        "instructions": specialInstructionController.text,
        "promo_code": isPromoCodeValid ? coupon?.code : null,
        "insurance_option": insuranceOne ? "3" : "7",
        "damage_waiver": damageWaiver,
        "payment_method": "stripe",
        "payment_status": "pending",
        "total_amount": totalAmount.toStringAsFixed(2),
      });
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
    } finally {
      isLoading = false;
      rebuildUi();
    }
  }
}
