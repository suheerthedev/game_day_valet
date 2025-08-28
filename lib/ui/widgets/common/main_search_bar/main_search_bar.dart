import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'main_search_bar_model.dart';

class MainSearchBar extends StackedView<MainSearchBarModel> {
  final TextEditingController controller;

  final bool isAutoFocus;
  final bool isReadOnly;
  final bool hasDatePicker;
  final Function()? onTextFieldTap;
  final Function(String)? onSubmitted;
  final Function()? onDatePickerTap;
  final String hintText;
  const MainSearchBar(
      {super.key,
      required this.controller,
      this.isAutoFocus = false,
      this.isReadOnly = false,
      this.hasDatePicker = false,
      this.onTextFieldTap,
      this.onSubmitted,
      this.onDatePickerTap,
      this.hintText = 'Search here...'});

  @override
  Widget builder(
    BuildContext context,
    MainSearchBarModel viewModel,
    Widget? child,
  ) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: controller,
        autofocus: isAutoFocus,
        readOnly: isReadOnly,
        onTap: onTextFieldTap,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        cursorColor: AppColors.primary,
        clipBehavior: Clip.hardEdge,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textHint,
          ),
          suffix: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => onSubmitted?.call(controller.text),
                child: Icon(IconsaxPlusLinear.search_normal_1,
                    size: 20.w, color: AppColors.textHint),
              ),
              if (hasDatePicker) ...[
                SizedBox(width: 10.w),
                InkWell(
                  onTap: onDatePickerTap,
                  child: const Icon(
                    IconsaxPlusLinear.calendar,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                )
              ]
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey100),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey500),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  @override
  MainSearchBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainSearchBarModel();
}
