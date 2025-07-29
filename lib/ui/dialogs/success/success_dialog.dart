import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/common/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'success_dialog_model.dart';

class SuccessDialog extends StackedView<SuccessDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SuccessDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SuccessDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/success.json',
              width: 100.w,
              height: 100.h,
              animate: true,
              repeat: true,
            ),
            Text(
              request.title!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
            verticalSpaceTiny,
            Text(
              request.description!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHint,
              ),
              maxLines: 3,
              softWrap: true,
            ),
            verticalSpaceMedium,
            GestureDetector(
              onTap: () => completer(DialogResponse(confirmed: false)),
              child: Container(
                height: 50.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Got it',
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SuccessDialogModel viewModelBuilder(BuildContext context) =>
      SuccessDialogModel();
}
