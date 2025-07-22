import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'sign_up_viewmodel.dart';

class SignUpView extends StackedView<SignUpViewModel> {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignUpViewModel viewModel,
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
                Text("""Create New 
Account""",
                    style: GoogleFonts.poppins(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    )),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: viewModel.goToSignIn,
                  child: Text.rich(TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                      children: [
                        TextSpan(
                            text: "Sign in",
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600))
                      ])),
                ),
                SizedBox(height: 30.h),
                TextField(
                  controller: viewModel.emailController,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    labelText: "Email",
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
                SizedBox(height: 20.h),
                TextField(
                  controller: viewModel.nameController,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    labelText: "Name",
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
                SizedBox(height: 20.h),
                TextField(
                  controller: viewModel.passwordController,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_outlined),
                    ),
                    suffixIconColor: AppColors.primary,
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
                SizedBox(height: 30.h),
                MainButton(
                    text: "Sign Up",
                    onTap: viewModel.onSignUp,
                    hasBorder: true,
                    color: AppColors.secondary,
                    borderColor: AppColors.white,
                    textColor: AppColors.white),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: AppColors.grey300,
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text("OR",
                          style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                    ),
                    const Expanded(
                        child: Divider(
                      color: AppColors.grey300,
                    ))
                  ],
                ),

                //Google Button
                SizedBox(height: 30.h),
                InkWell(
                  onTap: viewModel.onGoogleSignUp,
                  child: Container(
                      width: 340.w,
                      height: 58.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: BoxBorder.all(
                            width: 1.04.w, color: AppColors.primary),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.google,
                                size: 24.sp, color: AppColors.primary),
                            SizedBox(width: 10.w),
                            Text(
                              "Continue with Google",
                              style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      )),
                ),

                //Apple button
                SizedBox(height: 10.h),
                InkWell(
                  onTap: viewModel.onAppleSignUp,
                  child: Container(
                      width: 340.w,
                      height: 58.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: BoxBorder.all(
                            width: 1.04.w, color: AppColors.primary),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.apple,
                                size: 24.sp, color: AppColors.primary),
                            SizedBox(width: 10.w),
                            Text(
                              "Continue with Apple",
                              style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      )),
                ),

                //Terms and conditions
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                          text: "By signing up, you agree to our ",
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary),
                          children: [
                            TextSpan(
                                text: "Terms ",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: "and ",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: "Privacy Policy",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600))
                          ])),
                ),
              ],
            ),
          ),
        )));
  }

  @override
  SignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignUpViewModel();
}
