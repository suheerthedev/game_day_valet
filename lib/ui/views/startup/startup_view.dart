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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 20.h),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/logo/gdv_full_logo_white.png',
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "READY FOR GAME DAY CONVENIENCE?",
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                )),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     width: 366.w,
            //     height: 551.h,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20.r),
            //     ),
            //     clipBehavior: Clip.hardEdge,
            //     child: Image.asset(
            //       'assets/images/splash_image_2.png',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
