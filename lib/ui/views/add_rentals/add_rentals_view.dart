import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'add_rentals_viewmodel.dart';

class AddRentalsView extends StackedView<AddRentalsViewModel> {
  const AddRentalsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddRentalsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: MainAppBar(
        title: Text(
          'Latest Rental',
          style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                        child: TextField(
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 14.h,
                            ),
                            hintText: 'Search here...',
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
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.grey300),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.grey500),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      //Items
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 20.w,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 170.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        viewModel.items[index].image ?? '',
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      IconsaxPlusLinear.image,
                                      size: 40.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      viewModel.items[index].name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary),
                                    ),
                                    Text(
                                      "\$ ${viewModel.items[index].price}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Icon(
                                        IconsaxPlusLinear.add,
                                        size: 15.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Text(
                                      "01",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Icon(
                                        IconsaxPlusLinear.minus,
                                        size: 15.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),

                      //View Smart Suggestions
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          viewModel.toggleViewSmartSuggestions();
                        },
                        child: Text(
                          'View Smart Suggestions',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      if (viewModel.viewSmartSuggestions) ...[
                        SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.bundles.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 340.w,
                              height: 58.h,
                              decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: AppColors.grey100, width: 1.w)),
                              child: Row(
                                children: [
                                  Checkbox(
                                      activeColor: AppColors.secondary,
                                      checkColor: AppColors.white,
                                      splashRadius: 0,
                                      side: BorderSide(
                                          color: AppColors.textHint,
                                          width: 1.w),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.r))),
                                      value: false,
                                      onChanged: (value) {
                                        // viewModel.smartSuggestion = value ?? false;
                                        // viewModel.notifyListeners();
                                      }),
                                  Text(
                                    viewModel.bundles[index].totalItems ?? '',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 20.h),
                      MainButton(
                        text: 'Proceed to Checkout',
                        onTap: viewModel.proceedToCheckout,
                      ),
                      //View Smart Suggestions
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  AddRentalsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddRentalsViewModel();

  @override
  void onViewModelReady(AddRentalsViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
