import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onSignUp() {
    print(emailController.text);
    print(nameController.text);
    print(passwordController.text);
  }

  void onGoogleSignUp() {
    print("Google Sign Up");
  }

  void onAppleSignUp() {
    print("Apple Sign Up");
  }
}
