import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RentalBookingViewModel extends BaseViewModel {
  bool smartSuggestion = false;
  bool insuranceOne = false;
  bool insuranceTwo = false;
  bool stripe = false;
  bool applePay = false;
  bool googlePay = false;

  final TextEditingController tournamentController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController coachNameController = TextEditingController();
  final TextEditingController ageGroupController = TextEditingController();
  final TextEditingController gearNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();
  final TextEditingController specialInstructionController =
      TextEditingController();
}
