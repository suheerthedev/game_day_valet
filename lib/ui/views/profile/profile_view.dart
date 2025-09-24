import 'package:cached_network_image/cached_network_image.dart';
// import 'package:floating_chat_button/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: MainAppBar(
            hasLeading: true,
            hasSubtitle: true,
            leading: Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.secondary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.r),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl:
                          "${ApiConfig.baseUrl}/storage/${viewModel.currentUser?.profileImage}",
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        IconsaxPlusLinear.user,
                        size: 12.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
            title: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.6.sw,
              ),
              child: Text(
                viewModel.currentUser?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ),
            subtitle: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.6.sw,
              ),
              child: Text(
                viewModel.currentUser?.email ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHint),
              ),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        ListTile(
                          onTap: viewModel.onEditProfileTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.user,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Edit Profile',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onRentalHistoryTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.receipt_item,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Rental History',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onReferAndEarnTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.gift,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Refer and Earn',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onFavoritesTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.heart,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Favorites',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onPrivacyPolicyTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.shield_tick,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Privacy Policy',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onTermsAndConditionsTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.folder_open,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Terms & Conditions',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onFrequentlyAskedQuestionsTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.message_question,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Frequently Asked Questions',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 10.h),
                        ListTile(
                          onTap: viewModel.onSettingsTap,
                          tileColor: AppColors.grey600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          leading: Icon(IconsaxPlusBold.setting,
                              size: 24.w, color: AppColors.secondary),
                          title: Text('Settings',
                              style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                          trailing: Icon(IconsaxPlusLinear.arrow_right_3,
                              size: 24.w, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 20.h),
                        MainButton(
                          text: 'Logout',
                          onTap: viewModel.onLogoutTap,
                          textColor: AppColors.white,
                          borderColor: AppColors.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 20.h),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child:
                //   ),
                // ),
                // FloatingChatButton(
                //   onTap: (_) {
                //     viewModel.onChatTap();
                //   },
                //   chatIconWidget: const Padding(
                //     padding: EdgeInsets.all(14.0),
                //     child: Icon(
                //       IconsaxPlusLinear.message_2,
                //       color: AppColors.white,
                //       size: 24,
                //     ),
                //   ),
                //   messageBackgroundColor: AppColors.secondary,
                //   chatIconBorderColor: AppColors.secondary,
                //   chatIconBackgroundColor: AppColors.secondary,
                //   messageBorderWidth: 2,
                //   // messageText: "You've received a message!",
                //   messageTextStyle: GoogleFonts.poppins(
                //       fontSize: 14.sp,
                //       fontWeight: FontWeight.w400,
                //       color: AppColors.white),
                //   showMessageParameters: ShowMessageParameters(
                //       delayDuration: const Duration(seconds: 2),
                //       durationToShowMessage: const Duration(seconds: 5)),
                // )
              ],
            ),
          ),
        ),
        if (viewModel.isLoggingOut)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Logging out...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
