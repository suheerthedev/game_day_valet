import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'reset_password_viewmodel.dart';

class ResetPasswordView extends StackedView<ResetPasswordViewModel> {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ResetPasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
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
                SizedBox(
                  width: 340.w,
                  height: 58.h,
                  child: TextField(
                    controller: viewModel.newPasswordController,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textHint,
                      ),
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey100),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey100),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 340.w,
                  height: 58.h,
                  child: TextField(
                    controller: viewModel.confirmPasswordController,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textHint,
                      ),
                      filled: true,
                      fillColor: AppColors.grey50,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey100),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey100),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                MainButton(
                    text: "Done",
                    onTap: viewModel.onResetPassword,
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
  ResetPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ResetPasswordViewModel();
}
