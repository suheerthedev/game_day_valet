import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            "Settings",
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onNotificationsTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(IconsaxPlusBold.notification,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Notifications',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(
                      viewModel.isNotificationsEnabled ?? false
                          ? IconsaxPlusBold.toggle_on_circle
                          : IconsaxPlusLinear.toggle_off_circle,
                      size: 24.w,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onEmailNotificationsTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(IconsaxPlusBold.direct_normal,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Email Notifications',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(
                      viewModel.isEmailNotificationsEnabled ?? false
                          ? IconsaxPlusBold.toggle_on_circle
                          : IconsaxPlusLinear.toggle_off_circle,
                      size: 24.w,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onSmsNotificationsTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(IconsaxPlusBold.sms,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('SMS Notifications',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(
                      viewModel.isSmsNotificationsEnabled ?? false
                          ? IconsaxPlusBold.toggle_on_circle
                          : IconsaxPlusLinear.toggle_off_circle,
                      size: 24.w,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onDeleteAccountTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(IconsaxPlusBold.trash,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Delete Account',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                      size: 24.w, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        )));
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();

  @override
  void onViewModelReady(SettingsViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
