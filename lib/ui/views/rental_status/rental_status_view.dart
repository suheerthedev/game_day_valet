import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:floating_chat_button/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
        appBar: MainAppBar(
          title: Text(
            'Rental Status',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            viewModel.isBusy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.rentalStatus.isNotEmpty
                    ? _buildRentalActiveState(context, viewModel)
                    : _buildNoRentalState(context),
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
              // messageText: "You've received a message!",
              messageTextStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white),
              showMessageParameters: ShowMessageParameters(
                  delayDuration: const Duration(seconds: 2),
                  durationToShowMessage: const Duration(seconds: 5)),
            )
          ],
        )));
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.primary,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.image,
                          color: Colors.white,
                          size: 48.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Failed to load image',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoRentalState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Center(
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
      ),
    );
  }

  Widget _buildRentalActiveState(
      BuildContext context, RentalStatusViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo/gdv_full_logo_black.png',
              width: 1.sw,
              height: 0.15.sh,
            ),
            Divider(
              color: AppColors.grey300,
              thickness: 1,
              height: 50.h,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           "00",
            //           style: GoogleFonts.poppins(
            //               fontSize: 40.sp,
            //               fontWeight: FontWeight.w600,
            //               color: AppColors.textHint),
            //         ),
            //         Text(
            //           'hours',
            //           style: GoogleFonts.poppins(
            //               fontSize: 14.sp,
            //               fontWeight: FontWeight.w400,
            //               color: AppColors.textHint),
            //         ),
            //       ],
            //     ),
            //     Text(
            //       " : ",
            //       style: GoogleFonts.poppins(
            //           fontSize: 40.sp,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.textHint),
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           '${viewModel.timeRemaining}',
            //           style: GoogleFonts.poppins(
            //               fontSize: 40.sp,
            //               fontWeight: FontWeight.w600,
            //               color: AppColors.textSecondary),
            //         ),
            //         Text(
            //           'minutes',
            //           style: GoogleFonts.poppins(
            //               fontSize: 14.sp,
            //               fontWeight: FontWeight.w400,
            //               color: AppColors.textHint),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20.h),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "time left for delivery",
            //       style: GoogleFonts.poppins(
            //           fontSize: 14.sp,
            //           fontWeight: FontWeight.w500,
            //           color: AppColors.textHint),
            //     ),
            //   ],
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Icon(
                        viewModel.rentalStatus.last.status == 'pending'
                            ? IconsaxPlusBold.clock
                            : viewModel.rentalStatus.last.status == 'confirmed'
                                ? IconsaxPlusBold.tick_circle
                                : viewModel.rentalStatus.last.status ==
                                        'out_for_delivery'
                                    ? IconsaxPlusBold.car
                                    : viewModel.rentalStatus.last.status ==
                                            'delivered'
                                        ? IconsaxPlusBold.box
                                        : viewModel.rentalStatus.last.status ==
                                                'cancelled'
                                            ? IconsaxPlusBold.close_circle
                                            : IconsaxPlusBold.box_tick,
                        size: 70.sp,
                        color: AppColors.secondary),
                    SizedBox(height: 10.h),
                    Text(
                      viewModel.rentalStatus.last.status == 'pending'
                          ? 'Pending'
                          : viewModel.rentalStatus.last.status == 'confirmed'
                              ? 'Confirmed'
                              : viewModel.rentalStatus.last.status ==
                                      'out_for_delivery'
                                  ? 'Out for Delivery'
                                  : viewModel.rentalStatus.last.status ==
                                          'delivered'
                                      ? 'Delivered'
                                      : 'Cancelled',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: AppColors.secondary),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30.h),
            // Order tracking timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.rentalStatus.length,
              itemBuilder: (context, index) {
                final status = viewModel.rentalStatus[index];
                final isLastItem = index == viewModel.rentalStatus.length - 1;

                return _buildTimelineItem(
                  title: status.statusLabel ?? '',
                  timestamp: status.formattedUpdatedAt ?? '',
                  isLastItem: isLastItem,
                );
              },
            ),
            SizedBox(height: 20.h),
            // Text(
            //   'Return Instructions',
            //   style: GoogleFonts.poppins(
            //       fontSize: 18.sp,
            //       fontWeight: FontWeight.w600,
            //       color: AppColors.primary),
            // ),
            // SizedBox(height: 10.h),
            // MainTextField(
            //     label: 'Special Instructions',
            //     controller: viewModel.specialInstructionsController),
            SizedBox(height: 10.h),
            if (viewModel.rentalStatus.last.status == 'delivered') ...[
              Text(
                'Delivery Photos',
                style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
              ),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 123.w / 106.h,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    mainAxisExtent: 106.h),
                itemCount: viewModel.rentalStatus.last.imageUrls?.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    width: 123.w,
                    height: 106.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.grey300,
                        width: 1.w,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: GestureDetector(
                      onTap: () {
                        _showFullImage(
                            context,
                            viewModel.rentalStatus.last.imageUrls?[index] ??
                                '');
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            viewModel.rentalStatus.last.imageUrls?[index] ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          IconsaxPlusLinear.image,
                          color: AppColors.textHint,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50.h),
            ],
            // SizedBox(height: 10.h),
            // Text(
            //   'Give Review',
            //   style: GoogleFonts.poppins(
            //       fontSize: 18.sp,
            //       fontWeight: FontWeight.w600,
            //       color: AppColors.primary),
            // ),
            // SizedBox(height: 10.h),
            // MainTextField(
            //     label: 'Write Google Review Here',
            //     controller: viewModel.googleReviewController),

            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     'Need Help?',
            //     style: GoogleFonts.poppins(
            //         fontSize: 14.sp,
            //         fontWeight: FontWeight.w500,
            //         color: AppColors.textSecondary),
            //   ),
            // ),
            // SizedBox(height: 20.h),
            // MainButton(
            //   onTap: () {},
            //   text: 'Order More',
            //   color: AppColors.secondary,
            //   borderColor: AppColors.secondary,
            //   textColor: AppColors.white,
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String timestamp,
    required bool isLastItem,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Timeline dot
            Container(
              width: 11.w,
              height: 11.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLastItem ? AppColors.secondary : AppColors.grey300,
                // border: Border.all(
                //   color: isCompleted ? AppColors.secondary : AppColors.grey300,
                //   width: 3.w,
                // ),
              ),
            ),
            // Timeline line
            if (!isLastItem)
              DottedLine(
                direction: Axis.vertical,
                dashColor: AppColors.grey300,
                lineLength: 70.h,
                dashLength: 4,
                dashGapLength: 2,
                dashGapColor: Colors.transparent,
              ),
          ],
        ),
        SizedBox(width: 12.w),
        // Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.7.sp,
                color: isLastItem ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 12.sp,
                  color: AppColors.textHint,
                ),
                SizedBox(width: 4.w),
                Text(
                  timestamp,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.7.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  RentalStatusViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalStatusViewModel();
}
