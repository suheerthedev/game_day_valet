import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'main_search_bar_model.dart';

class MainSearchBar extends StackedView<MainSearchBarModel> {
  final TextEditingController controller;

  final bool isAutoFocus;
  final bool isReadOnly;
  final Function()? onTextFieldTap;
  final Function(String)? onSubmitted;
  final String hintText;
  const MainSearchBar(
      {super.key,
      required this.controller,
      this.isAutoFocus = false,
      this.isReadOnly = false,
      this.onTextFieldTap,
      this.onSubmitted,
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
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textHint,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 40.h,
          ),
          prefixIcon: IconButton(
            onPressed: () => onSubmitted?.call(controller.text),
            icon: Icon(FontAwesomeIcons.magnifyingGlass,
                size: 20.w, color: AppColors.textHint),
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
