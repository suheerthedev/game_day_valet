import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_viewmodel.dart';

class OnboardingView extends StackedView<OnboardingViewModel> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OnboardingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 20.h),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_image_1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 20.h,
                children: [
                  Text(
                      'Easily book premium tailgate gear and game-day rentals, making your event hassle-free and unforgettable.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          shadows: [
                            const Shadow(
                              color: AppColors.primary,
                              offset: Offset(0, 2),
                              blurRadius: 5,
                            ),
                          ],
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white)),
                  MainButton(
                      text: "Get Started",
                      onTap: viewModel.onGetStarted,
                      hasBorder: true,
                      borderColor: AppColors.white,
                      textColor: AppColors.white)
                ],
              ),
            ),
          )),
    );
  }

  @override
  OnboardingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OnboardingViewModel();
}
