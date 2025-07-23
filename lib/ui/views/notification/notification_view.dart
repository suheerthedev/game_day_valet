import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
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
          title: Text(
            'Notification',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 21.r,
                        backgroundColor: AppColors.secondary,
                        child: Text(
                            viewModel.notifications[index]['title']
                                .toString()
                                .toUpperCase()
                                .substring(0, 1),
                            style: GoogleFonts.poppins(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white)),
                      ),
                      title: Text(viewModel.notifications[index]['title'],
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      subtitle: Text(
                          viewModel.notifications[index]['description'],
                          style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textHint)),
                    );
                  },
                ))));
  }

  @override
  NotificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationViewModel();
}
