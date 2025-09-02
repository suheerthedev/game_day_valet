import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'notification_viewmodel.dart';

class NotificationView extends StackedView<NotificationViewModel> {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          hasNotification: false,
          title: Text(
            'Notification',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : viewModel.notifications.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: ListView.builder(
                          itemCount: viewModel.notifications.length +
                              (viewModel.hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == viewModel.notifications.length) {
                              // This is the "See More" button
                              return _buildLoadMoreButton(viewModel);
                            }

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 21.r,
                                backgroundColor: AppColors.secondary,
                                child: Text(
                                    viewModel.notifications[index].message
                                        .toString()
                                        .toUpperCase()
                                        .substring(0, 1),
                                    style: GoogleFonts.poppins(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.white)),
                              ),
                              title: Text(
                                  viewModel.notifications[index].message ?? '',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary)),
                              subtitle: Text(
                                  viewModel.notifications[index]
                                          .formattedTimeStamp ??
                                      '',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textHint)),
                            );
                          },
                        ),
                      )));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusBold.notification,
              size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No notifications yet',
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

  Widget _buildLoadMoreButton(NotificationViewModel viewModel) {
    return viewModel.isFetching
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: TextButton(
              onPressed: viewModel.loadMoreNotifications,
              child: Text(
                'See More',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();

  @override
  void onViewModelReady(NotificationViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }
}
