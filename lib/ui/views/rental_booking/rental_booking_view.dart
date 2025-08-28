import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'rental_booking_viewmodel.dart';

class RentalBookingView extends StackedView<RentalBookingViewModel> {
  const RentalBookingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RentalBookingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Rental Booking',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //DropDowns
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 131.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "SELECT DATE",
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary),
                          ),
                          Icon(IconsaxPlusLinear.arrow_down,
                              size: 20.w, color: AppColors.textPrimary)
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 131.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "SPORT TYPE",
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary),
                          ),
                          Icon(IconsaxPlusLinear.arrow_down,
                              size: 20.w,
                              color: const Color.fromRGBO(25, 33, 38, 1))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                MainTextField(
                  label: "Select Tournament",
                  controller: viewModel.tournamentController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: true,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconsaxPlusLinear.arrow_down)),
                  suffixIconColor: AppColors.textHint,
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Team Name",
                  controller: viewModel.teamNameController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: false,
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Coach Name",
                  controller: viewModel.coachNameController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: false,
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Age Group",
                  controller: viewModel.ageGroupController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: true,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconsaxPlusLinear.arrow_down)),
                  suffixIconColor: AppColors.textHint,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Gear Selection',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Gear Name",
                  controller: viewModel.gearNameController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: true,
                  suffixIcon: IconButton(
                      onPressed: () {
                        viewModel.isGearExpanded = !viewModel.isGearExpanded;
                        viewModel.notifyListeners();
                      },
                      icon: const Icon(IconsaxPlusLinear.arrow_down)),
                  suffixIconColor: AppColors.textHint,
                ),
                if (viewModel.isGearExpanded) ...[
                  Container(
                    width: 340.w,
                    height: 142.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey100),
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.gears.length,
                      itemBuilder: (context, index) {
                        final gear = viewModel.gears[index];
                        return _buildGearOption(
                          context,
                          // icon: network['image'],
                          name: gear['name'],
                          isLast: index == viewModel.gears.length - 1,
                          onPreviewImage: () {
                            viewModel.showMapPopup(
                                context, gear['image'], gear['name']);
                          },
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Quantity",
                  controller: viewModel.quantityController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: true,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconsaxPlusLinear.arrow_down)),
                  suffixIconColor: AppColors.textHint,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Smart Suggestion',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 340.w,
                  height: 58.h,
                  decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.grey100, width: 1.w)),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: AppColors.secondary,
                          checkColor: AppColors.white,
                          splashRadius: 0,
                          side:
                              BorderSide(color: AppColors.textHint, width: 1.w),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.r))),
                          value: viewModel.smartSuggestion,
                          onChanged: (value) {
                            viewModel.smartSuggestion = value ?? false;
                            viewModel.notifyListeners();
                          }),
                      Text(
                        "100 Chairs . 20 Lights . 4 Speakers . ",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Instruction',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Special Instruction",
                  controller: viewModel.specialInstructionController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: false,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Promo Code',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Apply Promo Code",
                  controller: viewModel.promoCodeController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                  hasSuffixIcon: false,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Add Insurance',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.secondary,
                        checkColor: AppColors.white,
                        splashRadius: 0,
                        side: BorderSide(color: AppColors.textHint, width: 1.w),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.r))),
                        value: viewModel.insuranceOne,
                        onChanged: (value) {
                          if (viewModel.insuranceTwo == true &&
                              viewModel.insuranceOne == false) {
                            viewModel.insuranceTwo = false;
                          }
                          viewModel.insuranceOne = value ?? false;
                          viewModel.notifyListeners();
                        }),
                    Text(
                      "3-Day Warranty – \$0.99",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.secondary,
                        checkColor: AppColors.white,
                        splashRadius: 0,
                        side: BorderSide(color: AppColors.textHint, width: 1.w),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.r))),
                        value: viewModel.insuranceTwo,
                        onChanged: (value) {
                          if (viewModel.insuranceOne == true &&
                              viewModel.insuranceTwo == false) {
                            viewModel.insuranceOne = false;
                          }
                          viewModel.insuranceTwo = value ?? false;
                          viewModel.notifyListeners();
                        }),
                    Expanded(
                      child: Text(
                        "7-Day Warranty – \$1.5 (Recommended)",
                        softWrap: true,
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Damage Waiver',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                Text(
                  'You have to pay \$20 if any gear get damaged.',
                  style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textHint),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Checkbox(
                        activeColor: AppColors.secondary,
                        checkColor: AppColors.white,
                        splashRadius: 0,
                        side: BorderSide(color: AppColors.textHint, width: 1.w),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.r))),
                        value: viewModel.damageWaiver,
                        onChanged: (value) {
                          viewModel.damageWaiver = value ?? false;
                          viewModel.notifyListeners();
                        }),
                    Text(
                      "Damage waiver for \$20",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                Text(
                  'Payment Method',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 340.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.grey100, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: AppColors.secondary,
                          checkColor: AppColors.white,
                          splashRadius: 0,
                          side:
                              BorderSide(color: AppColors.textHint, width: 1.w),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.r))),
                          value: viewModel.stripe,
                          onChanged: (value) {
                            if (viewModel.applePay == true ||
                                viewModel.googlePay == true) {
                              viewModel.applePay = false;
                              viewModel.googlePay = false;
                            }
                            viewModel.stripe = value ?? false;
                            viewModel.notifyListeners();
                          }),
                      Text(
                        "Stripe",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 340.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.grey100, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: AppColors.secondary,
                          checkColor: AppColors.white,
                          splashRadius: 0,
                          side:
                              BorderSide(color: AppColors.textHint, width: 1.w),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.r))),
                          value: viewModel.applePay,
                          onChanged: (value) {
                            if (viewModel.stripe == true ||
                                viewModel.googlePay == true) {
                              viewModel.stripe = false;
                              viewModel.googlePay = false;
                            }
                            viewModel.applePay = value ?? false;
                            viewModel.notifyListeners();
                          }),
                      Text(
                        "ApplePay",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 340.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.grey100, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: AppColors.secondary,
                          checkColor: AppColors.white,
                          splashRadius: 0,
                          side:
                              BorderSide(color: AppColors.textHint, width: 1.w),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.r))),
                          value: viewModel.googlePay,
                          onChanged: (value) {
                            if (viewModel.stripe == true ||
                                viewModel.applePay == true) {
                              viewModel.stripe = false;
                              viewModel.applePay = false;
                            }
                            viewModel.googlePay = value ?? false;
                            viewModel.notifyListeners();
                          }),
                      Text(
                        "GooglePay",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                MainButton(
                    text: 'Book Now',
                    onTap: () {},
                    textColor: AppColors.white,
                    borderColor: AppColors.secondary)
              ],
            ),
          ),
        )));
  }

  Widget _buildGearOption(
    BuildContext context, {
    // required String icon,
    required String name,
    required VoidCallback onPreviewImage,
    required bool isLast,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                ),
              ),
              GestureDetector(
                onTap: onPreviewImage,
                child: Text(
                  'Preview Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: AppColors.grey300,
            height: 1.h,
          ),
      ],
    );
  }

  @override
  RentalBookingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RentalBookingViewModel();
}
