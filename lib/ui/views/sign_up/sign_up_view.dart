import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'sign_up_viewmodel.dart';

class SignUpView extends StackedView<SignUpViewModel> {
  final String? referralCode;
  const SignUpView({Key? key, this.referralCode}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignUpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
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
                          MainTextField(
                            label: 'Name',
                            controller: viewModel.nameController,
                            labelColor: AppColors.textHint,
                            cursorColor: AppColors.primary,
                            fillColor: AppColors.grey50,
                            borderColor: AppColors.grey100,
                            enabledBorderColor: AppColors.grey100,
                            focusedBorderColor: AppColors.primary,
                            hasSuffixIcon: false,
                            // errorText: viewModel.nameError,
                          ),
                          if (viewModel.nameError != null)
                            Text(
                              viewModel.nameError ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),

                          SizedBox(height: 20.h),
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
                            // errorText: viewModel.emailError,
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
                                icon: Icon(
                                  viewModel.isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                )),
                            suffixIconColor: AppColors.primary,
                            // errorText: viewModel.passwordError,
                          ),
                          if (viewModel.passwordError != null)
                            Text(
                              viewModel.passwordError ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
                              ),
                            ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: 340.w,
                            height: 58.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: TextField(
                                      controller:
                                          viewModel.referralCodeController,
                                      obscureText: false,
                                      cursorColor: AppColors.primary,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        focusColor: AppColors.primary,
                                        labelText: 'Referral Code',
                                        labelStyle: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textHint,
                                        ),
                                        suffixIcon: viewModel
                                                .isReferralCodeValid
                                            ? const Icon(
                                                IconsaxPlusLinear.tick_circle,
                                                color: AppColors.success,
                                              )
                                            : null,
                                        filled: true,
                                        fillColor: AppColors.grey50,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.grey100),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.grey100),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.primary),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                SizedBox(
                                  height: 52.h,
                                  child: FloatingActionButton(
                                    elevation: 0,
                                    onPressed: viewModel.validateReferralCode,
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    child: Text(
                                      "Apply",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (viewModel.referralCodeError != null)
                            Text(
                              viewModel.referralCodeError ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.error,
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
                              text: "Sign Up",
                              onTap: viewModel.onSignUp,
                              hasBorder: true,
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
                                  border: Border.all(
                                      width: 1.04.w, color: AppColors.primary),
                                ),
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

                          //Apple button
                          // SizedBox(height: 10.h),
                          // InkWell(
                          //   onTap: viewModel.onAppleSignUp,
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
  SignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignUpViewModel(referralCode: referralCode);

  @override
  void onViewModelReady(SignUpViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
