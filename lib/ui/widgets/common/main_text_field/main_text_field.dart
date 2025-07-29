import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'main_text_field_model.dart';

class MainTextField extends StackedView<MainTextFieldModel> {
  final String label;
  final TextEditingController controller;
  final bool hasSuffixIcon;
  final Color? labelColor;
  final Color? cursorColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? suffixIconColor;
  final Widget? suffixIcon;
  final bool obscureText;
  final BorderRadius? borderRadius;
  const MainTextField({
    super.key,
    required this.label,
    required this.controller,
    this.labelColor,
    this.cursorColor,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.suffixIconColor,
    this.suffixIcon,
    this.hasSuffixIcon = false,
    this.obscureText = false,
    this.borderRadius,
  });

  @override
  Widget builder(
    BuildContext context,
    MainTextFieldModel viewModel,
    Widget? child,
  ) {
    return SizedBox(
      width: 340.w,
      height: 58.h,
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        cursorColor: cursorColor ?? AppColors.primary,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          focusColor: AppColors.primary,
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: labelColor ?? AppColors.textHint,
          ),
          suffixIcon: hasSuffixIcon ? suffixIcon : null,
          suffixIconColor: suffixIconColor ?? AppColors.primary,
          filled: true,
          fillColor: fillColor ?? AppColors.grey50,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.grey100),
            borderRadius: borderRadius ?? BorderRadius.circular(10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: enabledBorderColor ?? AppColors.grey100),
            borderRadius: borderRadius ?? BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: focusedBorderColor ?? AppColors.primary),
            borderRadius: borderRadius ?? BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  @override
  MainTextFieldModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainTextFieldModel();
}
