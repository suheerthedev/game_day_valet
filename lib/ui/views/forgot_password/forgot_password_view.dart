import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'forgot_password_viewmodel.dart';

class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
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
            child: viewModel.isBusy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("""Forgot 
Password""",
                              style: GoogleFonts.poppins(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              )),
                          SizedBox(height: 5.h),
                          Text(
                            "Enter your email to get code ",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          MainTextField(
                            label: 'Email',
                            controller: viewModel.emailController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: false,
                          ),
                          if (viewModel.emailError != null)
                            Text(
                              viewModel.emailError ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),
                          SizedBox(height: 30.h),
                          MainButton(
                              text: "Done",
                              onTap: viewModel.onForgotPassword,
                              hasBorder: true,
                              borderColor: AppColors.white,
                              textColor: AppColors.white),
                        ],
                      ),
                    ),
                  )));
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ForgotPasswordViewModel();
}
