import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:stacked/stacked.dart';

import 'rental_status_viewmodel.dart';

class RentalStatusView extends StackedView<RentalStatusViewModel> {
  const RentalStatusView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalStatusViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          // elevation: 10,
          // shadowColor: AppColors.primary.withOpacity(0.1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rental Status',
                style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.secondary.withOpacity(0.1),
                child: Center(
                  child: Icon(Iconsax.notification,
                      size: 24.w, color: AppColors.textPrimary),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: _buildNoRentalState(context))));
  }

  Widget _buildNoRentalState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/mascot.png',
            width: 162.w,
            height: 242.h,
          ),
          Text(
            'Oops!',
            style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          SizedBox(height: 5.h),
          Text(
            'There are no rentals',
            style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  @override
  RentalStatusViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalStatusViewModel();
}
