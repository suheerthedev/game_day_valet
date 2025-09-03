import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'main_item_card_model.dart';

class MainItemCard extends StackedView<MainItemCardModel> {
  final ItemModel item;
  final Function() onTapAdd;
  final Function() onTapRemove;
  final bool showQuantitySelector;
  const MainItemCard(
      {super.key,
      required this.item,
      required this.onTapAdd,
      required this.onTapRemove,
      this.showQuantitySelector = true});

  @override
  Widget builder(
    BuildContext context,
    MainItemCardModel viewModel,
    Widget? child,
  ) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 170.h,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(15.r),
          ),
          clipBehavior: Clip.hardEdge,
          child: CachedNetworkImage(
            imageUrl: item.imageUrl ?? '',
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(
              IconsaxPlusLinear.image,
              size: 40.sp,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100.w,
                child: Text(
                  item.name ?? '',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
              ),
              Text(
                "\$ ${item.price}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary),
              ),
            ],
          ),
        ),
        if (showQuantitySelector) ...[
          SizedBox(height: 5.h),
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onTapRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        IconsaxPlusLinear.minus,
                        size: 24.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  "${item.quantity}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary),
                ),
                GestureDetector(
                  onTap: onTapAdd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        IconsaxPlusLinear.add,
                        size: 24.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }

  @override
  MainItemCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainItemCardModel();
}
