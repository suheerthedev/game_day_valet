import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'bundles_summary_item_model.dart';

class BundlesSummaryItem extends StackedView<BundlesSummaryItemModel> {
  final BundleModel bundle;
  final Function(bool) onToggle;
  final VoidCallback onRemove;
  const BundlesSummaryItem({
    super.key,
    required this.bundle,
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
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                  imageUrl: bundle.image ?? '',
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ),
                      ),
                  errorWidget: (context, url, error) => Icon(
                      IconsaxPlusLinear.image,
                      size: 24.sp,
                      color: AppColors.grey400)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bundle.name ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  bundle.totalItems ?? '',
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
          SizedBox(width: 12.w),
          Checkbox(
              activeColor: AppColors.secondary,
              checkColor: AppColors.white,
              splashRadius: 0,
              side: BorderSide(color: AppColors.textHint, width: 1.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.r))),
              value: bundle.quantity > 0,
              onChanged: (value) {
                onToggle(value ?? false);
              }),
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
