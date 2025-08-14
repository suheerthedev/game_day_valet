import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'bundles_summary_item_model.dart';

class BundlesSummaryItem extends StackedView<BundlesSummaryItemModel> {
  final String name;
  final String totalItems;
  final bool isSelected;
  final Function(bool) onToggle;
  final VoidCallback onRemove;
  const BundlesSummaryItem({
    super.key,
    required this.name,
    required this.totalItems,
    required this.isSelected,
    required this.onToggle,
    required this.onRemove,
  });

  @override
  Widget builder(
    BuildContext context,
    BundlesSummaryItemModel viewModel,
    Widget? child,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              activeColor: AppColors.secondary,
              checkColor: AppColors.white,
              splashRadius: 0,
              side: BorderSide(color: AppColors.textHint, width: 1.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.r))),
              value: isSelected,
              onChanged: (value) {
                onToggle(value ?? false);
              }),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  totalItems,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  BundlesSummaryItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      BundlesSummaryItemModel();
}
