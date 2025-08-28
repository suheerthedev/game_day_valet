import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
    return Stack(
      children: [
        Scaffold(
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
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.rentalHistoryList.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.rentalHistoryList.length,
                                itemBuilder: (context, index) {
                                  final rental =
                                      viewModel.rentalHistoryList[index];
                                  return Container(
                                    width: 338.w,
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 14.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey900,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(rental.tournamentName ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    AppColors.textSecondary)),
                                        Text(rental.createdAt ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary)),
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
                                            text: rental.totalRentals ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textHint),
                                          )
                                        ])),
                                        SizedBox(height: 15.h),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              rental.paymentStatus == 'pending'
                                                  ? viewModel.completePayment(
                                                      context,
                                                      num.parse(
                                                          rental.totalAmount ??
                                                              '0'),
                                                      rental.id)
                                                  : null;
                                            },
                                            child: Container(
                                                height: 33.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                  color: rental.paymentStatus ==
                                                          'completed'
                                                      ? AppColors.grey500
                                                      : AppColors.secondary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    rental.paymentStatus ==
                                                            'completed'
                                                        ? 'Payment Completed'
                                                        : 'Payment Pending',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                      ),
          ),
        ),
        if (viewModel.isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.book_1,
              size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No rental history yet',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  @override
  RentalHistoryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalHistoryViewModel();

  @override
  void onViewModelReady(RentalHistoryViewModel viewModel) {
    viewModel.getRentalHistory();
    super.onViewModelReady(viewModel);
  }
}
