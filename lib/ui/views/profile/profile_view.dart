import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          hasLeading: true,
          hasSubtitle: true,
          leading: Row(
            children: [
              CircleAvatar(
                child: Image.asset('assets/images/pfp.png',
                    width: 50.w, height: 50.h),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          title: Text(
            'Katie',
            style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          subtitle: Text(
            'katie@gmail.com',
            style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHint),
          ),
        ),
        // appBar: AppBar(
        //   backgroundColor: AppColors.scaffoldBackground,
        //   surfaceTintColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Row(
        //         children: [
        //           CircleAvatar(
        //             child: Image.asset('assets/images/pfp.png',
        //                 width: 50.w, height: 50.h),
        //           ),
        //           SizedBox(width: 10.w),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'Katie',
        //                 style: GoogleFonts.poppins(
        //                     fontSize: 18.sp,
        //                     fontWeight: FontWeight.w700,
        //                     color: AppColors.textPrimary),
        //               ),
        //               Text(
        //                 'katie@gmail.com',
        //                 style: GoogleFonts.poppins(
        //                     fontSize: 12.sp,
        //                     fontWeight: FontWeight.w400,
        //                     color: AppColors.textHint),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //       CircleAvatar(
        //         radius: 20.r,
        //         backgroundColor: AppColors.secondary.withOpacity(0.1),
        //         child: Center(
        //           child: Icon(Iconsax.notification,
        //               size: 24.w, color: AppColors.textPrimary),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  onTap: viewModel.onEditProfileTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.user,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Edit Profile',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onRentalHistoryTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.receipt_item,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Rental History',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onFavoritesTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.heart,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Favorites',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onPrivacyPolicyTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.shield_tick,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Privacy Policy',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onReferAndEarnTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.gift,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Refer and Earn',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onFrequentlyAskedQuestionsTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.message_question,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Frequently Asked Questions',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.arrow_right_2,
                      size: 24.w, color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                ListTile(
                  onTap: viewModel.onNotificationsTap,
                  tileColor: AppColors.grey600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  leading: Icon(Iconsax.notification,
                      size: 24.w, color: AppColors.secondary),
                  title: Text('Notifications',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: Icon(Iconsax.toggle_off_circle_copy,
                      size: 24.w, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        )));
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
