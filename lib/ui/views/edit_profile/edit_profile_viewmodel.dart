import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EditProfileViewModel extends BaseViewModel {
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
}
