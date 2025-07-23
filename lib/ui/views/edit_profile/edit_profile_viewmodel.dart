import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void init() {
    nameController.text = 'Katie';
    emailController.text = 'katie@gmail.com';
    phoneController.text = '1234567890';
    addressController.text = '123 Main St, Anytown, USA';
    notifyListeners();
  }

  void save() {
    _navigationService.back();
  }
}
