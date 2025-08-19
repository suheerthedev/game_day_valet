import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'rental_summary_item_model.dart';

class RentalSummaryItem extends StackedView<RentalSummaryItemModel> {
  final ItemModel item;
  final VoidCallback onRemove;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const RentalSummaryItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget builder(
    BuildContext context,
    RentalSummaryItemModel viewModel,
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
                  imageUrl: item.image ?? '',
                  fit: BoxFit.cover,
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
                  item.name ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Stock Quantity: ${item.stock ?? 0}',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    InkWell(
                      onTap: onMinus,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(IconsaxPlusLinear.minus,
                            size: 16.sp, color: AppColors.white),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      item.quantity.toString().padLeft(2, '0'),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    InkWell(
                      onTap: onPlus,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(IconsaxPlusLinear.add,
                            size: 16.sp, color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onRemove,
            child: Icon(IconsaxPlusLinear.trash,
                color: AppColors.secondary, size: 20.sp),
          )
        ],
      ),
    );
  }

  @override
  RentalSummaryItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalSummaryItemModel();
}
