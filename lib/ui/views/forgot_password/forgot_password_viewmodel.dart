import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();

  void onForgotPassword() {
    print(emailController.text);
  }
}
