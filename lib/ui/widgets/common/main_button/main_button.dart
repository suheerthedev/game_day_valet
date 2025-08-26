import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'main_button_model.dart';

class MainButton extends StackedView<MainButtonModel> {
  final String text;
  final VoidCallback onTap;
  final bool hasBorder;
  final Color? textColor;
  final Color? borderColor;
  final bool isDisabled;
  const MainButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.hasBorder = false,
      this.textColor,
      this.borderColor,
      this.isDisabled = false});

  @override
  Widget builder(
    BuildContext context,
    MainButtonModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
          width: 340.w,
          height: 58.h,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.grey500,
                      AppColors.grey500,
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFC94C4C),
                      Color(0xFF192126),
                    ],
                  ),
            borderRadius: BorderRadius.circular(10.r),
            border: hasBorder
                ? Border.all(
                    width: 1.04.w, color: borderColor ?? AppColors.white)
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.white),
            ),
          )),
    );
  }

  @override
  MainButtonModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainButtonModel();
}
