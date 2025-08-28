import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'refer_and_earn_viewmodel.dart';

class ReferAndEarnView extends StackedView<ReferAndEarnViewModel> {
  const ReferAndEarnView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ReferAndEarnViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Refer & Earn',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Center(
                  child: viewModel.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/refer_and_earn.png',
                                width: 274.w,
                                height: 242.h,
                              ),
                              Text(
                                'Share GDV, Score Credit!',
                                style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Give your friends \$5 off their first rental and get \$5 in credit when they book!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textHint),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                  width: 338.w,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                        width: 1.04.w, color: AppColors.white),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Code: ',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.white),
                                        ),
                                        Text(
                                          viewModel.referralCode ?? '',
                                          style: GoogleFonts.poppins(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => viewModel.copyToClipboard(
                                        viewModel.referralCode ?? ''),
                                    child: Container(
                                        width: 163.w,
                                        height: 58.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                              width: 1.04.w,
                                              color: AppColors.secondary),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(IconsaxPlusLinear.copy,
                                                  size: 24.w,
                                                  color:
                                                      AppColors.textSecondary),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Copy Code',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .textSecondary),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () => viewModel.shareReferralLink(),
                                    child: Container(
                                        width: 163.w,
                                        height: 58.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                              width: 1.04.w,
                                              color: AppColors.secondary),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(FontAwesomeIcons.share,
                                                  size: 24.w,
                                                  color:
                                                      AppColors.textSecondary),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Share',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .textSecondary),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 20.h),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'My Cash Reward',
                              //           style: GoogleFonts.poppins(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w600,
                              //               color: AppColors.textPrimary),
                              //         ),
                              //         Text(
                              //           '\$15.00',
                              //           style: GoogleFonts.poppins(
                              //               fontSize: 16.sp,
                              //               fontWeight: FontWeight.w600,
                              //               color: AppColors.textPrimary),
                              //         ),
                              //       ],
                              //     ),
                              //     InkWell(
                              //         onTap: () {},
                              //         child: Container(
                              //           width: 115.w,
                              //           height: 34.h,
                              //           decoration: BoxDecoration(
                              //             color: AppColors.white,
                              //             borderRadius:
                              //                 BorderRadius.circular(10.r),
                              //             border: Border.all(
                              //                 width: 1.04.w,
                              //                 color: AppColors.secondary),
                              //           ),
                              //           child: Center(
                              //             child: Text(
                              //               'Withdraw',
                              //               style: GoogleFonts.poppins(
                              //                   fontSize: 14.sp,
                              //                   fontWeight: FontWeight.w500,
                              //                   color: AppColors.textSecondary),
                              //             ),
                              //           ),
                              //         ))
                              //   ],
                              // ),
                              // SizedBox(height: 20.h),
                              // LinearProgressIndicator(
                              //   value: viewModel.progress,
                              //   backgroundColor: AppColors.grey300,
                              //   color: AppColors.secondary,
                              //   minHeight: 10.h,
                              // ),
                              // SizedBox(height: 20.h),
                              // Text.rich(TextSpan(children: [
                              //   TextSpan(
                              //       text: 'You have earned ',
                              //       style: GoogleFonts.poppins(
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w400,
                              //           color: AppColors.textPrimary)),
                              //   TextSpan(
                              //       text:
                              //           '\$${viewModel.currentValue.toStringAsFixed(2)}',
                              //       style: GoogleFonts.poppins(
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w700,
                              //           color: AppColors.textSecondary)),
                              // ])),
                              // Divider(
                              //   color: AppColors.grey300,
                              //   thickness: 1.w,
                              // ),
                              // Text.rich(TextSpan(children: [
                              //   TextSpan(
                              //       text: 'Earn ',
                              //       style: GoogleFonts.poppins(
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w400,
                              //           color: AppColors.textPrimary)),
                              //   TextSpan(
                              //       text:
                              //           '\$${viewModel.finalValue.toStringAsFixed(2)}',
                              //       style: GoogleFonts.poppins(
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w700,
                              //           color: AppColors.textSecondary)),
                              //   TextSpan(
                              //       text: ' to unlock a free tournament bundle',
                              //       style: GoogleFonts.poppins(
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w400,
                              //           color: AppColors.textPrimary)),
                              // ])),
                              // SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                ))));
  }

  @override
  ReferAndEarnViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReferAndEarnViewModel();

  @override
  void onViewModelReady(ReferAndEarnViewModel viewModel) {
    viewModel.calculateProgress();
    viewModel.getReferralData();
    super.onViewModelReady(viewModel);
  }
}
