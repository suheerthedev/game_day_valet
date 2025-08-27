import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/coupon_model.dart';
import 'package:game_day_valet/models/settings_item_model.dart';
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

  List<SettingsItemModel> get insuranceOptions =>
      _rentalService.insuranceOptions;
  List<SettingsItemModel> get damageWaiverOptions =>
      _rentalService.damageWaiverOptions;

  TextEditingController teamNameController = TextEditingController();
  TextEditingController coachNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  String teamNameError = '';
  String coachNameError = '';
  String phoneNumberError = '';
  String emailError = '';
  // String fieldNumberError = '';

  void init() {
    emailController.text = user?.email ?? '';
    phoneNumberController.text = user?.contactNumber ?? '';
  }

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
    if (phoneNumberController.text.isEmpty) {
      isValid = false;
      phoneNumberError = 'Phone number is required';
    }
    if (emailController.text.isEmpty) {
      isValid = false;
      emailError = 'Email is required';
    }
    //  if (fieldNumberController.text.isEmpty) {
    //   isValid = false;
    //   fieldNumberError = 'Field number is required';
    // }
    rebuildUi();
    return isValid;
  }

  double totalAmount = 0;

  void calculateTotalAmount() {
    double subtotal = 0;

    // Items
    for (final item in items) {
      final double itemPrice = double.tryParse(item.price ?? '0') ?? 0;
      subtotal += itemPrice * (item.quantity);
    }

    // Selected bundles only
    for (final bundle in bundles) {
      if (bundle.isSelected) {
        final double bundlePrice = double.tryParse(bundle.price ?? '0') ?? 0;
        subtotal += bundlePrice;
      }
    }

    // Selected insurance (single select)
    for (final option in insuranceOptions) {
      if (option.isSelected) {
        subtotal += (option.price).toDouble();
        break;
      }
    }

    // Selected damage waiver (single select)
    for (final option in damageWaiverOptions) {
      if (option.isSelected) {
        subtotal += (option.price).toDouble();
        break;
      }
    }

    double finalTotal = subtotal;
    if (isPromoCodeValid && coupon != null) {
      if (coupon?.type == "fixed") {
        finalTotal = subtotal - (double.tryParse(coupon?.value ?? '0') ?? 0);
      } else if (coupon?.type == "percent") {
        final double percent = double.tryParse(coupon?.value ?? '0') ?? 0;
        finalTotal = subtotal * (1 - (percent / 100));
      }
    }

    if (finalTotal < 0) finalTotal = 0;
    totalAmount = finalTotal;
  }

  // Future<void> pickDropOffDateTime(BuildContext context) async {
  //   final DateTime now = DateTime.now();
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: now,
  //     firstDate: now.subtract(const Duration(days: 0)),
  //     lastDate: DateTime(now.year + 5),
  //   );
  //   if (pickedDate == null) return;

  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     // ignore: use_build_context_synchronously
  //     context: context,
  //     initialTime: TimeOfDay(hour: now.hour, minute: 0),
  //   );
  //   if (pickedTime == null) return;

  //   final DateTime combined = DateTime(
  //     pickedDate.year,
  //     pickedDate.month,
  //     pickedDate.day,
  //     pickedTime.hour,
  //     pickedTime.minute,
  //   );

  //   // Format as "YYYY-MM-DD HH:MM:SS"
  //   final String formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(combined);
  //   dropOffTimeController.text = formatted;
  //   notifyListeners();
  // }

  bool isRentalSummaryExpanded = true;

  bool isLoading = false;

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
          await _rentalService.applyPromoCode(promoCodeController.text.trim(), {
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
    bundle.isSelected = !bundle.isSelected;
    calculateTotalAmount();
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

  void toggleInsurance(SettingsItemModel insurance) {
    SettingsItemModel? previouslySelected;
    for (final option in insuranceOptions) {
      if (option.isSelected) {
        previouslySelected = option;
        break;
      }
    }

    if (insurance.isSelected) {
      insurance.isSelected = false;
    } else {
      if (previouslySelected != null) {
        previouslySelected.isSelected = false;
      }
      insurance.isSelected = true;
    }

    calculateTotalAmount();
    rebuildUi();
  }

  void toggleDamageWaiver(SettingsItemModel damageWaiver) {
    SettingsItemModel? previouslySelected;
    for (final option in damageWaiverOptions) {
      if (option.isSelected) {
        previouslySelected = option;
        break;
      }
    }

    if (damageWaiver.isSelected) {
      damageWaiver.isSelected = false;
    } else {
      if (previouslySelected != null) {
        previouslySelected.isSelected = false;
      }
      damageWaiver.isSelected = true;
    }

    calculateTotalAmount();
    rebuildUi();
  }

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
    // Recalculate totals with the currently applied coupon
    calculateTotalAmount();
  }

  void removeDiscount() {
    // Clear coupon and recalculate to base amounts
    isPromoCodeValid = false;
    coupon = null;
    calculateTotalAmount();
    notifyListeners();
  }

  Future<void> bookRental(BuildContext context) async {
    if (!validateForm()) {
      return;
    }

    SettingsItemModel? selectedInsurance;
    for (final option in insuranceOptions) {
      if (option.isSelected) {
        selectedInsurance = option;
        break;
      }
    }

    SettingsItemModel? selectedDamageWaiver;
    for (final option in damageWaiverOptions) {
      if (option.isSelected) {
        selectedDamageWaiver = option;
        break;
      }
    }

    final body = {
      "tournament_id": tournamentId,
      "team_name_with_age_group": teamNameController.text,
      "coach_name": coachNameController.text,
      "phone_number": phoneNumberController.text,
      "email": emailController.text,
      // "field_number": "Field 5",
      "items": formatItems(items),
      "bundles": formatBundles(bundles),
      "rental_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      // "drop_off_time": dropOffTimeController.text,
      "instructions": specialInstructionController.text,
      "promo_code": isPromoCodeValid ? coupon?.code : null,
      "insurance_option": selectedInsurance?.price,
      "damage_waiver": selectedDamageWaiver?.price,
      "payment_method": "stripe",
      "payment_status": "pending",
      "total_amount": totalAmount.toStringAsFixed(2),
    };

    logger.info("Booking rental body: $body");

    try {
      isLoading = true;
      rebuildUi();
      await _rentalService.createRentalBooking(context, totalAmount, body);
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
