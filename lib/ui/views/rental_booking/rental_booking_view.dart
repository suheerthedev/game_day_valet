import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:stacked/stacked.dart';

import 'rental_booking_viewmodel.dart';

class RentalBookingView extends StackedView<RentalBookingViewModel> {
  const RentalBookingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalBookingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rental Booking',
                    style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.secondary.withOpacity(0.1),
                    child: Center(
                      child: Icon(Iconsax.notification,
                          size: 24.w, color: AppColors.textPrimary),
                    ),
                  )
                ],
              )
            ],
          ),
        )));
  }

  @override
  RentalBookingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalBookingViewModel();
}
