import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    final double screenHeight = 1.sh;
    // Show the bottom image only on sufficiently tall screens to avoid overflow
    final bool showBottomImage = screenHeight >= 700;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 20.h),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/logo/gdv_full_logo_white.png',
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Text(
              "READY FOR GAME DAY CONVENIENCE?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 28.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 5.h),
            const CircularProgressIndicator(
              color: AppColors.white,
            ),
            const Expanded(
              flex: 10,
              child: SizedBox(),
            ),
            if (showBottomImage)
              Container(
                width: double.infinity,
                height: 0.3.sh,
                margin: EdgeInsets.symmetric(horizontal: 10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/splash_image_3.png',
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
