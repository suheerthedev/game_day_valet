import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'reset_password_viewmodel.dart';

class ResetPasswordView extends StackedView<ResetPasswordViewModel> {
  final String email;
  final String code;
  const ResetPasswordView({Key? key, required this.email, required this.code})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ResetPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          surfaceTintColor: AppColors.scaffoldBackground,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("""Reset 
Password""",
                          style: GoogleFonts.poppins(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          )),
                      SizedBox(height: 5.h),
                      Text(
                        "Enter your new password",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      MainTextField(
                        label: 'New Password',
                        controller: viewModel.passwordController,
                        labelColor: AppColors.textHint,
                        cursorColor: AppColors.primary,
                        fillColor: AppColors.grey50,
                        borderColor: AppColors.grey100,
                        enabledBorderColor: AppColors.grey100,
                        focusedBorderColor: AppColors.primary,
                        hasSuffixIcon: true,
                        obscureText: viewModel.passwordVisible,
                        suffixIcon: IconButton(
                            onPressed: () {
                              viewModel.togglePasswordVisibility();
                            },
                            icon: viewModel.passwordVisible
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined)),
                        suffixIconColor: AppColors.primary,
                      ),
                      SizedBox(height: 20.h),
                      MainTextField(
                        label: 'Confirm Password',
                        controller: viewModel.confirmPasswordController,
                        labelColor: AppColors.textHint,
                        cursorColor: AppColors.primary,
                        fillColor: AppColors.grey50,
                        borderColor: AppColors.grey100,
                        enabledBorderColor: AppColors.grey100,
                        focusedBorderColor: AppColors.primary,
                        hasSuffixIcon: true,
                        obscureText: !viewModel.confirmPasswordVisible,
                        suffixIcon: IconButton(
                            onPressed: () {
                              viewModel.toggleConfirmPasswordVisibility();
                            },
                            icon: viewModel.confirmPasswordVisible
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined)),
                        suffixIconColor: AppColors.primary,
                      ),
                      SizedBox(height: 30.h),
                      MainButton(
                          text: "Done",
                          onTap: viewModel.onResetPassword,
                          hasBorder: true,
                          borderColor: AppColors.white,
                          textColor: AppColors.white),
                    ],
                  ),
                ),
        )));
  }

  @override
  ResetPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ResetPasswordViewModel(email: email, code: code);
}
