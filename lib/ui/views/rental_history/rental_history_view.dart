import 'package:floating_chat_button/floating_chat_button.dart';
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
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.rentalHistoryList.isEmpty
                    ? _buildEmptyState()
                    : Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        viewModel.rentalHistoryList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 338.w,
                                        height: 152.h,
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 14.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.grey900,
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    viewModel
                                                            .rentalHistoryList[
                                                                index]
                                                            .tournamentName ??
                                                        '',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .textSecondary)),
                                                Text(
                                                    DateFormat('dd-MM-yyyy').format(
                                                        DateTime.parse(viewModel
                                                                .rentalHistoryList[
                                                                    index]
                                                                .rentalDate ??
                                                            '')),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .textPrimary)),
                                                Text(
                                                    viewModel
                                                            .rentalHistoryList[
                                                                index]
                                                            .fieldNumber ??
                                                        '',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textHint)),
                                                SizedBox(height: 10.h),
                                                Text.rich(TextSpan(children: [
                                                  TextSpan(
                                                    text: 'Rentals: ',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColors.textHint),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '100 Chairs . 20 Lights . 4 Speakers',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.textHint),
                                                  )
                                                ])),
                                              ],
                                            ),
                                            // Align(
                                            //   alignment: Alignment.topRight,
                                            //   child: Icon(Iconsax.heart_copy,
                                            //       size: 24.w,
                                            //       color: AppColors.secondary),
                                            // ),
                                            // Align(
                                            //   alignment: Alignment.bottomRight,
                                            //   child: InkWell(
                                            //     onTap: () {},
                                            //     child: Container(
                                            //         width: 121.w,
                                            //         height: 33.h,
                                            //         decoration: BoxDecoration(
                                            //           color: AppColors.secondary,
                                            //           borderRadius:
                                            //               BorderRadius.circular(
                                            //                   10.r),
                                            //         ),
                                            //         child: Center(
                                            //           child: Text(
                                            //             'Order Again',
                                            //             style: GoogleFonts.poppins(
                                            //                 fontSize: 16.sp,
                                            //                 fontWeight:
                                            //                     FontWeight.w500,
                                            //                 color: AppColors.white),
                                            //           ),
                                            //         )),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          FloatingChatButton(
                            onTap: (_) {
                              viewModel.onChatTap();
                            },
                            chatIconWidget: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Icon(
                                Iconsax.message_2_copy,
                                color: AppColors.white,
                                size: 24,
                              ),
                            ),
                            messageBackgroundColor: AppColors.secondary,
                            chatIconBorderColor: AppColors.secondary,
                            chatIconBackgroundColor: AppColors.secondary,
                            messageBorderWidth: 2,
                            messageText: "You've received a message!",
                            messageTextStyle: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white),
                            showMessageParameters: ShowMessageParameters(
                                delayDuration: const Duration(seconds: 2),
                                durationToShowMessage:
                                    const Duration(seconds: 5)),
                          )
                        ],
                      )));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.book_1, size: 40.w, color: AppColors.secondary),
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
