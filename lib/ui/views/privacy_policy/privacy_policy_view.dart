import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'privacy_policy_viewmodel.dart';

class PrivacyPolicyView extends StackedView<PrivacyPolicyViewModel> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PrivacyPolicyViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          hasSubtitle: true,
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
          subtitle: Text(
            'Last Updated: December 08, 2023',
            style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHint),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        '1. Acceptance of Terms',
                        'By using GDV, you agree to these Terms of Service. If you do not agree, please do not use our platform.',
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        '2. User Conduct',
                        'You Agree Not to:',
                        bulletPoints: [
                          'Violate any laws or regulations.',
                          'Use our platform for any unlawful or unauthorized purpose.',
                          'Transmit any viruses, malware, or harmful code.',
                          'Attempt to gain unauthorized access to our systems.',
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        '4. Privacy',
                        'Our Privacy Policy explains how we collect, use, and protect your information. By using GDV, you consent to the practices outlined in our Privacy Policy.',
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        '5. Termination',
                        'We reserve the right to terminate or suspend your account for any reason without notice.',
                      ),
                      SizedBox(height: 24.h),
                      _buildSection(
                        '5. Damage Waiver',
                        'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ))));
  }

  Widget _buildSection(String title, String content,
      {List<String>? bulletPoints}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textHint,
            height: 1.5,
          ),
        ),
        if (bulletPoints != null) ...[
          SizedBox(height: 12.h),
          ...bulletPoints
              .map((point) => Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 4.w,
                          height: 4.w,
                          margin: EdgeInsets.only(top: 8.h, right: 12.w),
                          decoration: const BoxDecoration(
                            color: AppColors.textHint,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            point,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textHint,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ],
    );
  }

  @override
  PrivacyPolicyViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PrivacyPolicyViewModel();
}
