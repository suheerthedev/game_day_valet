import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/common/ui_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'confirmation_dialog_model.dart';

const double _graphicSize = 60;

class ConfirmationDialog extends StackedView<ConfirmationDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ConfirmationDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              request.title ?? 'Are you sure you want to proceed?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              request.description ?? 'Are you sure you want to proceed?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
              ),
            ),
            const Divider(
              color: AppColors.grey200,
              height: 30,
            ),
            GestureDetector(
              onTap: () => completer(DialogResponse(confirmed: true)),
              child: Text(
                request.mainButtonTitle ?? 'Yes',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
            const Divider(
              color: AppColors.grey200,
              height: 30,
            ),
            GestureDetector(
              onTap: () => completer(DialogResponse(confirmed: false)),
              child: Text(
                request.secondaryButtonTitle ?? 'No',
                style: GoogleFonts.poppins(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ConfirmationDialogModel viewModelBuilder(BuildContext context) =>
      ConfirmationDialogModel();
}
