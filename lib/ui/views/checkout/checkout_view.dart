import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/bundles_summary_item/bundles_summary_item.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_text_field/main_text_field.dart';
import 'package:game_day_valet/ui/widgets/common/rental_summary_item/rental_summary_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'checkout_viewmodel.dart';

class CheckoutView extends StackedView<CheckoutViewModel> {
  final int tournamentId;
  final List<ItemModel> items;
  final List<BundleModel> bundles;
  const CheckoutView(
      {Key? key,
      required this.tournamentId,
      required this.items,
      required this.bundles})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CheckoutViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Checkout',
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
                // Row(
                //   children: [
                //     const Spacer(),
                //     Container(
                //       width: 131.w,
                //       height: 40.h,
                //       decoration: BoxDecoration(
                //           color: const Color(0xFFF4F4F4),
                //           borderRadius: BorderRadius.circular(10.r)),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             "SELECT DATE",
                //             style: GoogleFonts.poppins(
                //                 fontSize: 12.sp,
                //                 fontWeight: FontWeight.w500,
                //                 color: AppColors.textPrimary),
                //           ),
                //           Icon(IconsaxPlusLinear.arrow_down,
                //               size: 20.w, color: AppColors.textPrimary)
                //         ],
                //       ),
                //     ),
                //     SizedBox(width: 10.w),
                //     Container(
                //       width: 131.w,
                //       height: 40.h,
                //       decoration: BoxDecoration(
                //           color: const Color(0xFFF4F4F4),
                //           borderRadius: BorderRadius.circular(10.r)),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Text(
                //             "SPORT TYPE",
                //             style: GoogleFonts.poppins(
                //                 fontSize: 12.sp,
                //                 fontWeight: FontWeight.w500,
                //                 color: AppColors.textPrimary),
                //           ),
                //           Icon(IconsaxPlusLinear.arrow_down,
                //               size: 20.w,
                //               color: const Color.fromRGBO(25, 33, 38, 1))
                //         ],
                //       ),
                //     ),
                //   ],
                // ),

                //View Rental Summary DropDown
                GestureDetector(
                  onTap: () {
                    viewModel.toggleRentalSummaryExpanded();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "View Rental Summary",
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint),
                      ),
                      SizedBox(width: 10.w),
                      AnimatedRotation(
                        turns: viewModel.isRentalSummaryExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Icon(
                          IconsaxPlusLinear.arrow_down,
                          size: 18.w,
                          color: AppColors.grey400,
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  crossFadeState: viewModel.isRentalSummaryExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                  firstChild: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border:
                              Border.all(color: AppColors.grey200, width: 1.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 12.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Amount: \$${viewModel.totalAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary),
                              ),
                              if (viewModel.items.isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                Text(
                                  'Items',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 10.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.items.length,
                                  itemBuilder: (context, index) {
                                    final item = viewModel.items[index];
                                    return RentalSummaryItem(
                                      name: item.name ?? '',
                                      quantityText:
                                          'Stock Quantity: ${item.stock ?? 0}',
                                      count: item.quantity,
                                      imageUrl: item.image,
                                      onRemove: () =>
                                          viewModel.removeItemFromSummary(item),
                                      onMinus: () =>
                                          viewModel.decrementItemQuantity(item),
                                      onPlus: () =>
                                          viewModel.incrementItemQuantity(item),
                                    );
                                  },
                                ),
                              ],
                              if (viewModel.bundles.isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                Text(
                                  'Bundles',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary),
                                ),
                                SizedBox(height: 10.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.bundles.length,
                                  itemBuilder: (context, index) {
                                    final bundle = viewModel.bundles[index];
                                    return BundlesSummaryItem(
                                      name: bundle.name ?? '',
                                      totalItems:
                                          'Total Items: ${bundle.totalItems}',
                                      isSelected: bundle.isSelected,
                                      onToggle: (value) {
                                        viewModel.toggleBundle(bundle);
                                      },
                                      onRemove: () => viewModel
                                          .removeBundleFromSummary(bundle),
                                    );
                                  },
                                )
                              ],
                              // ...viewModel.items.asMap().entries.map((entry) {
                              //   final int index = entry.key;
                              //   final item = entry.value;
                              //   return Column(
                              //     children: [
                              //       _RentalSummaryRow(
                              //         name: item.name ?? '',
                              //         quantityText:
                              //             'Stock Quantity: ${item.stock ?? 0}',
                              //         count: item.quantity == 0
                              //             ? 1
                              //             : item.quantity,
                              //         imageUrl: item.image,
                              //         onRemove: () =>
                              //             viewModel.removeItemFromSummary(item),
                              //         onMinus: () =>
                              //             viewModel.decrementItemQuantity(item),
                              //         onPlus: () =>
                              //             viewModel.incrementItemQuantity(item),
                              //       ),
                              //       if (index != viewModel.items.length - 1)
                              //         Padding(
                              //           padding: EdgeInsets.symmetric(
                              //               vertical: 10.h),
                              //           child: const Divider(
                              //               height: 1,
                              //               color: AppColors.grey200),
                              //         ),
                              //     ],
                              //   );
                              // }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                SizedBox(height: 20.h),
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
                  label: "Field Number (eg. Field 5)",
                  controller: viewModel.fieldNumberController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.primary,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Drop-Off',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 10.h),
                MainTextField(
                  label: "Estimated Drop-Off Time",
                  readOnly: true,
                  controller: viewModel.dropOffTimeController,
                  labelColor: AppColors.textHint,
                  cursorColor: AppColors.primary,
                  fillColor: AppColors.grey50,
                  borderColor: AppColors.grey100,
                  enabledBorderColor: AppColors.grey100,
                  focusedBorderColor: AppColors.grey100,
                  hasSuffixIcon: true,
                  suffixIcon: const Icon(IconsaxPlusLinear.calendar),
                  onTap: () async {
                    await viewModel.pickDropOffDateTime(context);
                  },
                  suffixIconColor: AppColors.textHint,
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

                // SizedBox(height: 20.h),
                // Text(
                //   'Payment Method',
                //   style: GoogleFonts.poppins(
                //       fontSize: 18.sp,
                //       fontWeight: FontWeight.w600,
                //       color: AppColors.textPrimary),
                // ),
                // SizedBox(height: 10.h),
                // Container(
                //   width: 340.w,
                //   height: 32.h,
                //   decoration: BoxDecoration(
                //     color: AppColors.grey50,
                //     borderRadius: BorderRadius.circular(10.r),
                //     border: Border.all(color: AppColors.grey100, width: 1.w),
                //   ),
                //   child: Row(
                //     children: [
                //       Checkbox(
                //           activeColor: AppColors.secondary,
                //           checkColor: AppColors.white,
                //           splashRadius: 0,
                //           side:
                //               BorderSide(color: AppColors.textHint, width: 1.w),
                //           shape: RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(2.r))),
                //           value: viewModel.stripe,
                //           onChanged: (value) {
                //             // if (viewModel.googlePay == true) {
                //             //   viewModel.googlePay = false;
                //             // }
                //             viewModel.stripe = value ?? false;
                //             viewModel.notifyListeners();
                //           }),
                //       Text(
                //         "Stripe",
                //         style: GoogleFonts.poppins(
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.textHint),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10.h),
                // Container(
                //   width: 340.w,
                //   height: 32.h,
                //   decoration: BoxDecoration(
                //     color: AppColors.grey50,
                //     borderRadius: BorderRadius.circular(10.r),
                //     border: Border.all(color: AppColors.grey100, width: 1.w),
                //   ),
                //   child: Row(
                //     children: [
                //       Checkbox(
                //           activeColor: AppColors.secondary,
                //           checkColor: AppColors.white,
                //           splashRadius: 0,
                //           side:
                //               BorderSide(color: AppColors.textHint, width: 1.w),
                //           shape: RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(2.r))),
                //           value: viewModel.applePay,
                //           onChanged: (value) {
                //             if (viewModel.stripe == true ||
                //                 viewModel.googlePay == true) {
                //               viewModel.stripe = false;
                //               viewModel.googlePay = false;
                //             }
                //             viewModel.applePay = value ?? false;
                //             viewModel.notifyListeners();
                //           }),
                //       Text(
                //         "ApplePay",
                //         style: GoogleFonts.poppins(
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.textHint),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10.h),
                // Container(
                //   width: 340.w,
                //   height: 32.h,
                //   decoration: BoxDecoration(
                //     color: AppColors.grey50,
                //     borderRadius: BorderRadius.circular(10.r),
                //     border: Border.all(color: AppColors.grey100, width: 1.w),
                //   ),
                //   child: Row(
                //     children: [
                //       Checkbox(
                //           activeColor: AppColors.secondary,
                //           checkColor: AppColors.white,
                //           splashRadius: 0,
                //           side:
                //               BorderSide(color: AppColors.textHint, width: 1.w),
                //           shape: RoundedRectangleBorder(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(2.r))),
                //           value: viewModel.googlePay,
                //           onChanged: (value) {
                //             if (viewModel.stripe == true) {
                //               viewModel.stripe = false;
                //             }
                //             viewModel.googlePay = value ?? false;
                //             viewModel.notifyListeners();
                //           }),
                //       Text(
                //         "GooglePay",
                //         style: GoogleFonts.poppins(
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.w500,
                //             color: AppColors.textHint),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 20.h),
                MainButton(
                    text: 'Book Now',
                    onTap: () {
                      viewModel.bookRental(context);
                    },
                    textColor: AppColors.white,
                    color: AppColors.secondary,
                    borderColor: AppColors.secondary)
              ],
            ),
          ),
        )));
  }

  @override
  CheckoutViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CheckoutViewModel(
          items: items, bundles: bundles, tournamentId: tournamentId);

  @override
  void onViewModelReady(CheckoutViewModel viewModel) {
    viewModel.calculateTotalAmount();
    super.onViewModelReady(viewModel);
  }
}
