import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select City',
                            style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary)),
                        Text(
                          'New York, United States',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        )
                      ],
                    ),
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: AppColors.secondary.withOpacity(0.1),
                      child: Center(
                        child: Icon(Iconsax.notification,
                            size: 24.w, color: AppColors.textPrimary),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 40.h,
                  child: TextField(
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText:
                          'Search tournament by name, date, location, host',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textHint,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                      prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                          size: 20.w, color: AppColors.textHint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey100),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.grey500),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Select Sport To Begin: ${viewModel.selectedSport}',
                            style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.8,
                                minChildSize: 0.6,
                                maxChildSize: 0.85,
                                builder: (context, scrollController) =>
                                    Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.r),
                                      topRight: Radius.circular(25.r),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Sport',
                                        style: GoogleFonts.poppins(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        'Select a sport to begin exploring tournaments.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textHint,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: viewModel.sports.length,
                                          itemBuilder: (context, index) {
                                            final sport =
                                                viewModel.sports[index];
                                            final isSelected =
                                                viewModel.selectedSport ==
                                                    sport;

                                            return InkWell(
                                              onTap: () {
                                                viewModel.selectedSport = sport;
                                                Navigator.pop(context);
                                                viewModel.rebuildUi();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 16.h),
                                                margin: EdgeInsets.only(
                                                    bottom: 8.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: AppColors.textHint
                                                          .withOpacity(0.1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      sport,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons.check,
                                                        color:
                                                            AppColors.primary,
                                                        size: 20.sp,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                              width: 140.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10.r),
                                border: BoxBorder.all(
                                    width: 1.04.w, color: AppColors.white),
                              ),
                              child: Center(
                                child: Text(
                                  'Select',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
