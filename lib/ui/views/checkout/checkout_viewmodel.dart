import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CheckoutViewModel extends BaseViewModel {
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
}
