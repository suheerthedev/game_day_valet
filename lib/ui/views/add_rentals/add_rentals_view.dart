import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_item_card/main_item_card.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'add_rentals_viewmodel.dart';

class AddRentalsView extends StackedView<AddRentalsViewModel> {
  final int tournamentId;
  const AddRentalsView({Key? key, required this.tournamentId})
      : super(key: key);

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
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainSearchBar(
                            isAutoFocus: false,
                            isReadOnly: true,
                            controller: viewModel.searchController,
                            onTextFieldTap: () {
                              viewModel.navigateToSearch(
                                  viewModel.searchController.text);
                            },
                          ),

                          //View Smart Suggestions
                          // SizedBox(height: 20.h),
                          // GestureDetector(
                          //   onTap: () {
                          //     viewModel.toggleViewSmartSuggestions();
                          //   },
                          //   child: Text(
                          //     'View Smart Suggestions',
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 16.sp,
                          //       fontWeight: FontWeight.w600,
                          //       color: AppColors.secondary,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20.h),
                          Text(
                            'Bundles',
                            style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                          if (viewModel.bundles.isEmpty) ...[
                            buildEmptyBundles(),
                          ],

                          if (viewModel.bundles.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFE082),
                                    Color(0xFFFFB300),
                                  ],
                                ), // Light golden color
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    child: Row(
                                      children: [
                                        Icon(
                                          IconsaxPlusBold.star,
                                          color: const Color(0xFFFFB300),
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          'Best Value Bundles',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF5D4037),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: viewModel.bundles.length,
                                    itemBuilder: (context, index) {
                                      final bundle = viewModel.bundles[index];
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 5.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          // border: Border.all(
                                          //     color: AppColors.grey100,
                                          //     width: 1.w),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 56.w,
                                              height: 56.w,
                                              decoration: BoxDecoration(
                                                  color: AppColors.grey50,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  border: Border.all(
                                                      color: AppColors.grey100,
                                                      width: 1.w)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        bundle.image ?? '',
                                                    fit: BoxFit.contain,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Color(
                                                                    0xFFFFB300),
                                                              ),
                                                            ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Icon(
                                                            IconsaxPlusLinear
                                                                .image,
                                                            size: 24.sp,
                                                            color: AppColors
                                                                .grey400)),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bundle.name ?? '',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    bundle.totalItems ?? '',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.h),
                                                  Text(
                                                    "\$ ${bundle.price}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFF9C4),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () => viewModel
                                                        .removeBundle(bundle),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4.w),
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: const Color(
                                                            0xFFFFF9C4),
                                                        size: 18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.w),
                                                    child: Text(
                                                      '${bundle.quantity}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () => viewModel
                                                        .addBundle(bundle),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4.w),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: const Color(
                                                            0xFFFFF9C4),
                                                        size: 18.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],

                          //Items

                          SizedBox(height: 20.h),
                          Text(
                            'Items',
                            style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                          if (viewModel.items.isEmpty) ...[
                            buildEmptyItems(),
                          ],
                          if (viewModel.items.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.6,
                                mainAxisSpacing: 10.h,
                                crossAxisSpacing: 20.w,
                              ),
                              itemBuilder: (context, index) {
                                return MainItemCard(
                                  item: viewModel.items[index],
                                  onTapAdd: () {
                                    viewModel.addItem(viewModel.items[index]);
                                  },
                                  onTapRemove: () {
                                    viewModel
                                        .removeItem(viewModel.items[index]);
                                  },
                                );
                              },
                            ),
                          ],
                          //View Smart Suggestions
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: MainButton(
          text: 'Proceed to Checkout',
          onTap: viewModel.proceedToCheckout,
          isDisabled: viewModel.isProceedToCheckoutDisabled,
        ),
      ),
    );
  }

  Widget buildEmptyItems() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.emoji_sad,
              size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No items found',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyBundles() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusLinear.emoji_sad,
              size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No bundles found',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  @override
  AddRentalsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddRentalsViewModel(tournamentId: tournamentId);

  @override
  void onViewModelReady(AddRentalsViewModel viewModel) {
    viewModel.getTournamentRentalItems();
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(AddRentalsViewModel viewModel) {
    viewModel.resetItemsandBundles();
    super.onDispose(viewModel);
  }
}
