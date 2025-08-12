import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_item_card/main_item_card.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:game_day_valet/ui/widgets/common/secondary_tournament_card/secondary_tournament_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'search_viewmodel.dart';

class SearchView extends StackedView<SearchViewModel> {
  final bool isTournamentSearch;
  final bool isItemSearch;
  const SearchView(
      {Key? key, this.isTournamentSearch = false, this.isItemSearch = false})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SearchViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: MainSearchBar(
              controller: viewModel.searchController,
              isAutoFocus: true,
              onSubmitted: (value) {
                if (isTournamentSearch) {
                  viewModel.searchTournaments(value);
                }
                if (isItemSearch) {
                  viewModel.searchItems(value);
                }
              })),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : viewModel.tournaments.isEmpty && viewModel.items.isEmpty
                ? _buildEmptyView()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        isTournamentSearch
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.tournaments.length,
                                itemBuilder: (context, index) {
                                  return SecondaryTournamentCard(
                                    tournament: viewModel.tournaments[index],
                                    onBookNowTap: () {},
                                    onTapFavorite: () {},
                                  );
                                },
                              )
                            : GridView.builder(
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
                                      viewModel
                                          .removeItem(viewModel.items[index]);
                                    },
                                  );
                                },
                              ),
                        SizedBox(height: 20.h),
                        // if (viewModel.hasMoreProducts)
                        //   Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 32),
                        //       child: SmallButton(
                        //         title: 'Show More',
                        //         onTap: () {
                        //           if (viewModel.isBrandSearch == true) {
                        //             viewModel.loadMoreProductsByBrand(brand!.id);
                        //           } else if (viewModel.isCountrySearch == true) {
                        //             viewModel.loadMoreProductsByCountry(country!);
                        //           } else {
                        //             viewModel.loadMoreProducts();
                        //           }
                        //         },
                        //         bgColor: AppColors.white,
                        //         textColor: AppColors.secondary,
                        //         borderColor: AppColors.secondary,
                        //         isLoading: viewModel.isLoading,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              IconsaxPlusLinear.search_normal,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 15),
            Text(
              isTournamentSearch ? "No Tournament Found" : "No Item Found",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Text(
                isTournamentSearch
                    ? "When you search for tournaments, they'll appear here."
                    : "When you search for items, they'll appear here.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SearchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchViewModel(
          isTournamentSearch: isTournamentSearch, isItemSearch: isItemSearch);
}
