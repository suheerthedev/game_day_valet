import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'sign_in_viewmodel.dart';

class SignInView extends StackedView<SignInViewModel> {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignInViewModel viewModel,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("""Sign In To Your
Account""",
                              style: GoogleFonts.poppins(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              )),
                          SizedBox(height: 5.h),
                          GestureDetector(
                            onTap: viewModel.goToSignUp,
                            child: Text.rich(TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary),
                                children: [
                                  TextSpan(
                                      text: "Sign up",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w600))
                                ])),
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

                          SizedBox(height: 20.h),
                          MainTextField(
                            label: 'Password',
                            controller: viewModel.passwordController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: true,
                            obscureText: !viewModel.isPasswordVisible,
                            suffixIcon: IconButton(
                                onPressed: viewModel.togglePasswordVisibility,
                                icon: viewModel.isPasswordVisible
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(
                                        Icons.visibility_off_outlined)),
                            suffixIconColor: AppColors.primary,
                          ),
                          if (viewModel.passwordError != null)
                            Text(
                              viewModel.passwordError ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: viewModel.goToForgotPassword,
                              child: Text("Forgot Password?",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary)),
                            ),
                          ),

                          // if (viewModel.generalError != null)
                          //   Padding(
                          //     padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                          //     child: Container(
                          //       padding: EdgeInsets.all(10.w),
                          //       decoration: BoxDecoration(
                          //         color: AppColors.error.withOpacity(0.1),
                          //         borderRadius: BorderRadius.circular(8.r),
                          //       ),
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Icon(
                          //             Icons.error_outline,
                          //             color: AppColors.error,
                          //             size: 16.sp,
                          //           ),
                          //           SizedBox(width: 8.w),
                          //           Expanded(
                          //             child: Text(
                          //               viewModel.generalError!,
                          //               style: GoogleFonts.poppins(
                          //                 color: AppColors.error,
                          //                 fontSize: 14.sp,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          SizedBox(height: 30.h),
                          MainButton(
                              text: "Sign In",
                              onTap: viewModel.onSignIn,
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
                            onTap: viewModel.onGoogleSignIn,
                            child: Container(
                                width: 340.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      width: 1.04.w, color: AppColors.primary),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.google,
                                          size: 24.sp,
                                          color: AppColors.primary),
                                      SizedBox(width: 10.w),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 200.w,
                                        ),
                                        child: Text(
                                          "Continue with Google",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),

                          // //Apple button
                          // SizedBox(height: 10.h),
                          // InkWell(
                          //   onTap: viewModel.onAppleSignIn,
                          //   child: Container(
                          //       width: 340.w,
                          //       height: 58.h,
                          //       decoration: BoxDecoration(
                          //         color: AppColors.white,
                          //         borderRadius: BorderRadius.circular(10.r),
                          //         border: Border.all(
                          //             width: 1.04.w, color: AppColors.primary),
                          //       ),
                          //       child: Center(
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             FaIcon(FontAwesomeIcons.apple,
                          //                 size: 24.sp,
                          //                 color: AppColors.primary),
                          //             SizedBox(width: 10.w),
                          //             Text(
                          //               "Continue with Apple",
                          //               style: GoogleFonts.poppins(
                          //                   fontSize: 16.sp,
                          //                   fontWeight: FontWeight.w500,
                          //                   color: AppColors.primary),
                          //             ),
                          //           ],
                          //         ),
                          //       )),
                          // ),

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
  SignInViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignInViewModel();
}
