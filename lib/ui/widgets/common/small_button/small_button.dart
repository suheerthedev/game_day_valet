import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'small_button_model.dart';

class SmallButton extends StackedView<SmallButtonModel> {
  final String title;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final bool isLoading;
  const SmallButton({
    super.key,
    required this.title,
    required this.onTap,
    this.height,
    this.width,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    this.isLoading = false,
  });

  @override
  Widget builder(
    BuildContext context,
    SmallButtonModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 170.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 100.w,
                        ),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
              ],
            ),
          )),
    );
  }

  @override
  SmallButtonModel viewModelBuilder(
    BuildContext context,
  ) =>
      SmallButtonModel();
}
