import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_button/main_button.dart';
import 'package:game_day_valet/ui/widgets/common/main_item_card/main_item_card.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
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
                          SizedBox(height: 20.h),

                          //Items
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.items.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
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
                                  viewModel.removeItem(viewModel.items[index]);
                                },
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
                                final bundle = viewModel.bundles[index];
                                return Container(
                                  width: 340.w,
                                  height: 58.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.grey50,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          color: AppColors.grey100,
                                          width: 1.w)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                activeColor: AppColors
                                                    .secondary,
                                                checkColor: AppColors.white,
                                                splashRadius: 0,
                                                side: BorderSide(
                                                    color: AppColors.textHint,
                                                    width: 1.w),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                2.r))),
                                                value: bundle.isSelected,
                                                onChanged: (value) {
                                                  viewModel
                                                      .toggleBundle(bundle);
                                                }),
                                            Text(
                                              bundle.totalItems ?? '',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textPrimary),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: Text(
                                          "\$ ${bundle.price}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],

                          //View Smart Suggestions
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: MainButton(
                          text: 'Proceed to Checkout',
                          onTap: viewModel.proceedToCheckout,
                          isDisabled: viewModel.isProceedToCheckoutDisabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
