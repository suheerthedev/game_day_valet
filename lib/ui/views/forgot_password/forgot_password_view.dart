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
                            "Email your email to get code ",
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
                          if (viewModel.generalError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                              child: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        viewModel.generalError!,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.error,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: 30.h),
                          MainButton(
                              text: "Done",
                              onTap: viewModel.onForgotPassword,
                              hasBorder: true,
                              color: AppColors.secondary,
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
