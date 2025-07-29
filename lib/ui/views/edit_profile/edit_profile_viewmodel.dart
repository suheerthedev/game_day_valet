import 'package:flutter/material.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/user_model.dart';
import 'package:game_day_valet/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EditProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();

  UserModel? get currentUser => _userService.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void init() {
    nameController.text = currentUser?.name ?? '';
    emailController.text = currentUser?.email ?? '';
    // phoneController.text = currentUser?.address?.phone ?? '';
    addressController.text = currentUser?.address?.streetAddress ?? '';
    notifyListeners();
  }

  void save() {
    _navigationService.back();
  }
}
