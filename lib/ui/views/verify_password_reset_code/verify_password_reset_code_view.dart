import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';

import 'verify_password_reset_code_viewmodel.dart';

class VerifyPasswordResetCodeView
    extends StackedView<VerifyPasswordResetCodeViewModel> {
  final String email;
  const VerifyPasswordResetCodeView({Key? key, required this.email})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    VerifyPasswordResetCodeViewModel viewModel,
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
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("""Verify 
OTP""",
                        style: GoogleFonts.poppins(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        )),
                    SizedBox(height: 5.h),
                    GestureDetector(
                      onTap: () {},
                      child: Text.rich(TextSpan(
                          text: "Enter the code sent to your email: ",
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                          children: [
                            TextSpan(
                                text: email,
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600))
                          ])),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: Pinput(
                        controller: viewModel.otpController,
                        onChanged: (value) {
                          viewModel.validateOtp(value);
                        },
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 50.w,
                          height: 50.h,
                          textStyle: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey50,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.grey500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: MainButton(
                          text: "Verify",
                          isDisabled: viewModel.isDisabled,
                          onTap: () {
                            viewModel.onVerifyOtp(
                                email, viewModel.otpController.text);
                          },
                          hasBorder: true,
                          color: AppColors.secondary,
                          borderColor: AppColors.white,
                          textColor: AppColors.white),
                    ),
                  ],
                ))),
      ),
    );
  }

  @override
  VerifyPasswordResetCodeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VerifyPasswordResetCodeViewModel();
}
