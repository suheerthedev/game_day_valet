import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:stacked/stacked.dart';

import 'rental_history_viewmodel.dart';

class RentalHistoryView extends StackedView<RentalHistoryViewModel> {
  const RentalHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalHistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Rental History',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 338.w,
                      height: 152.h,
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.grey900,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tournament Name",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary)),
                              Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now()),
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary)),
                              Text("Address here",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textHint)),
                              SizedBox(height: 10.h),
                              Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: 'Rentals: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textHint),
                                ),
                                TextSpan(
                                  text: '100 Chairs . 20 Lights . 4 Speakers',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textHint),
                                )
                              ])),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(Iconsax.heart_copy,
                                size: 24.w, color: AppColors.secondary),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                  width: 121.w,
                                  height: 33.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Order Again',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.white),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        )));
  }

  @override
  RentalHistoryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalHistoryViewModel();
}
