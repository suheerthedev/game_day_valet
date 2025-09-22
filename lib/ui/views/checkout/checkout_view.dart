import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/bundle_model.dart';
import 'package:game_day_valet/models/item_model.dart';
import 'package:game_day_valet/models/tournament_model.dart';
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
  final TournamentModel tournament;
  final List<ItemModel> items;
  final List<BundleModel> bundles;
  const CheckoutView(
      {Key? key,
      required this.tournament,
      required this.items,
      required this.bundles})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CheckoutViewModel viewModel,
    Widget? child,
  ) {
    return Stack(
      children: [
        Scaffold(
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
                            turns:
                                viewModel.isRentalSummaryExpanded ? 0.5 : 0.0,
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
                              border: Border.all(
                                  color: AppColors.grey200, width: 1.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.items.length,
                                      itemBuilder: (context, index) {
                                        final item = viewModel.items[index];
                                        return RentalSummaryItem(
                                          item: item,
                                          onRemove: () => viewModel
                                              .removeItemFromSummary(item),
                                          onMinus: () => viewModel
                                              .decrementItemQuantity(item),
                                          onPlus: () => viewModel
                                              .incrementItemQuantity(item),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.bundles.length,
                                      itemBuilder: (context, index) {
                                        final bundle = viewModel.bundles[index];
                                        return BundlesSummaryItem(
                                          bundle: bundle,
                                          onMinus: () => viewModel
                                              .decrementBundleQuantity(bundle),
                                          onPlus: () => viewModel
                                              .incrementBundleQuantity(bundle),
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
                      label: "Team Name/Age Group",
                      controller: viewModel.teamNameController,
                      labelColor: AppColors.textHint,
                      cursorColor: AppColors.primary,
                      fillColor: AppColors.grey50,
                      borderColor: AppColors.grey100,
                      enabledBorderColor: AppColors.grey100,
                      focusedBorderColor: AppColors.primary,
                      hasSuffixIcon: false,
                    ),
                    if (viewModel.teamNameError.isNotEmpty) ...[
                      Text(
                        viewModel.teamNameError,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error),
                      ),
                    ],
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
                    if (viewModel.coachNameError.isNotEmpty) ...[
                      Text(
                        viewModel.coachNameError,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error),
                      ),
                    ],
                    SizedBox(height: 10.h),
                    MainTextField(
                      label: "Email",
                      controller: viewModel.emailController,
                      labelColor: AppColors.textHint,
                      cursorColor: AppColors.primary,
                      fillColor: AppColors.grey50,
                      borderColor: AppColors.grey100,
                      enabledBorderColor: AppColors.grey100,
                      focusedBorderColor: AppColors.primary,
                      hasSuffixIcon: false,
                    ),
                    if (viewModel.emailError.isNotEmpty) ...[
                      Text(
                        viewModel.emailError,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error),
                      ),
                    ],
                    SizedBox(height: 10.h),
                    MainTextField(
                      label: "Phone Number",
                      controller: viewModel.phoneNumberController,
                      labelColor: AppColors.textHint,
                      cursorColor: AppColors.primary,
                      fillColor: AppColors.grey50,
                      borderColor: AppColors.grey100,
                      enabledBorderColor: AppColors.grey100,
                      focusedBorderColor: AppColors.primary,
                      hasSuffixIcon: false,
                    ),
                    if (viewModel.phoneNumberError.isNotEmpty) ...[
                      Text(
                        viewModel.phoneNumberError,
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.error),
                      ),
                    ],
                    // SizedBox(height: 10.h),
                    // MainTextField(
                    //   label: "Field Number (eg. Field 5)",
                    //   controller: viewModel.fieldNumberController,
                    //   labelColor: AppColors.textHint,
                    //   cursorColor: AppColors.primary,
                    //   fillColor: AppColors.grey50,
                    //   borderColor: AppColors.grey100,
                    //   enabledBorderColor: AppColors.grey100,
                    //   focusedBorderColor: AppColors.primary,
                    // ),
                    // if (viewModel.fieldNumberError.isNotEmpty) ...[
                    //   Text(
                    //     viewModel.fieldNumberError,
                    //     style: GoogleFonts.poppins(
                    //         fontSize: 12.sp,
                    //         fontWeight: FontWeight.w500,
                    //         color: AppColors.error),
                    //   ),
                    // ],
                    // SizedBox(height: 20.h),
                    // Text(
                    //   'Drop-Off',
                    //   style: GoogleFonts.poppins(
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.w600,
                    //       color: AppColors.textPrimary),
                    // ),
                    // SizedBox(height: 10.h),
                    // MainTextField(
                    //   label: "Estimated Drop-Off Time",
                    //   readOnly: true,
                    //   controller: viewModel.dropOffTimeController,
                    //   labelColor: AppColors.textHint,
                    //   cursorColor: AppColors.primary,
                    //   fillColor: AppColors.grey50,
                    //   borderColor: AppColors.grey100,
                    //   enabledBorderColor: AppColors.grey100,
                    //   focusedBorderColor: AppColors.grey100,
                    //   hasSuffixIcon: true,
                    //   suffixIcon: const Icon(IconsaxPlusLinear.calendar),
                    //   onTap: () async {
                    //     await viewModel.pickDropOffDateTime(context);
                    //   },
                    //   suffixIconColor: AppColors.textHint,
                    // ),

                    // SizedBox(height: 20.h),
                    // Text(
                    //   'Rental Days',
                    //   style: GoogleFonts.poppins(
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.w600,
                    //       color: AppColors.textPrimary),
                    // ),
                    // SizedBox(height: 10.h),
                    // MainTextField(
                    //   keyboardType: TextInputType.number,
                    //   label: "Enter Rental Days (Optional)",
                    //   controller: viewModel.rentalDaysController,
                    //   labelColor: AppColors.textHint,
                    //   cursorColor: AppColors.primary,
                    //   fillColor: AppColors.grey50,
                    //   borderColor: AppColors.grey100,
                    //   enabledBorderColor: AppColors.grey100,
                    //   focusedBorderColor: AppColors.primary,
                    //   hasSuffixIcon: false,
                    // ),
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
                    SizedBox(
                      width: 340.w,
                      height: 58.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: TextField(
                                controller: viewModel.promoCodeController,
                                obscureText: false,
                                cursorColor: AppColors.primary,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  focusColor: AppColors.primary,
                                  labelText: 'Promo Code',
                                  labelStyle: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textHint,
                                  ),
                                  suffixIcon: viewModel.isBusy
                                      ? Container(
                                          width: 20.w,
                                          height: 20.h,
                                          padding: EdgeInsets.all(10.r),
                                          child:
                                              const CircularProgressIndicator(
                                            color: AppColors.primary,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : viewModel.isPromoCodeValid
                                          ? const Icon(
                                              IconsaxPlusLinear.tick_circle,
                                              color: AppColors.success,
                                            )
                                          : null,
                                  filled: true,
                                  fillColor: AppColors.grey50,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.grey100),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.grey100),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primary),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            height: 52.h,
                            child: FloatingActionButton(
                              elevation: 0,
                              onPressed: viewModel.validatePromoCode,
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (viewModel.promoCodeError != null)
                      Text(
                        viewModel.promoCodeError ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.error,
                        ),
                      ),

                    if (viewModel.insuranceOptions.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Add Insurance',
                        style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 10.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.insuranceOptions.length,
                        itemBuilder: (context, index) {
                          final insurance = viewModel.insuranceOptions[index];
                          return Row(
                            children: [
                              Checkbox(
                                  activeColor: AppColors.secondary,
                                  checkColor: AppColors.white,
                                  splashRadius: 0,
                                  side: BorderSide(
                                      color: AppColors.textHint, width: 1.w),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.r))),
                                  value: insurance.isSelected,
                                  onChanged: (value) {
                                    viewModel.toggleInsurance(insurance);
                                  }),
                              Expanded(
                                child: Text(
                                  "${insurance.label} – \$${insurance.price}",
                                  softWrap: true,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],

                    if (viewModel.damageWaiverOptions.isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Damage Waiver',
                        style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 10.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.damageWaiverOptions.length,
                        itemBuilder: (context, index) {
                          final option = viewModel.damageWaiverOptions[index];
                          return Row(
                            children: [
                              Checkbox(
                                  activeColor: AppColors.secondary,
                                  checkColor: AppColors.white,
                                  splashRadius: 0,
                                  side: BorderSide(
                                      color: AppColors.textHint, width: 1.w),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.r))),
                                  value: option.isSelected,
                                  onChanged: (value) {
                                    viewModel.toggleDamageWaiver(option);
                                  }),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.label,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textPrimary),
                                    ),
                                    if (option.description != null) ...[
                                      Text(
                                        option.description ?? '',
                                        style: GoogleFonts.poppins(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textHint),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],

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
                          FocusScope.of(context).unfocus();
                          viewModel.bookRental(context);
                        },
                        textColor: AppColors.white,
                        borderColor: AppColors.secondary)
                  ],
                ),
              ),
            ),
          ),
        ),
        if (viewModel.isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            ),
          ),
      ],
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CheckoutViewModel(items: items, bundles: bundles, tournament: tournament);

  @override
  void onViewModelReady(CheckoutViewModel viewModel) {
    viewModel.init();
    viewModel.calculateTotalAmount();
    super.onViewModelReady(viewModel);
  }
}
