import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_item_card/main_item_card.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_tournament_card/main_tournament_card.dart';
import 'package:game_day_valet/ui/widgets/common/small_button/small_button.dart';
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
          surfaceTintColor: Colors.white,
          title: MainSearchBar(
              controller: viewModel.searchController,
              isAutoFocus: true,
              hasDatePicker: isTournamentSearch,
              onDatePickerTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: AppColors.primary,
                        colorScheme:
                            const ColorScheme.light(primary: AppColors.primary),
                        buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  viewModel.selectDate(picked);
                }
              },
              onSubmitted: (value) {
                if (isTournamentSearch) {
                  viewModel.searchTournaments(value);
                }
                if (isItemSearch) {
                  viewModel.searchItems(value);
                }
              })),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
        ),
        child: Column(
          children: [
            // if (isTournamentSearch)
            //   Padding(
            //     padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            //     child: _buildDateSelector(context, viewModel),
            //   ),
            Expanded(
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.tournaments.length,
                                      itemBuilder: (context, index) {
                                        final tournament =
                                            viewModel.tournaments[index];
                                        return MainTournamentCard(
                                          tournament: tournament,
                                          onTapMap: () {},
                                          onBookNowTap: () {
                                            viewModel.navigateToRentalBook(
                                                tournament.id);
                                          },
                                          onTapFavorite: () {
                                            viewModel
                                                .toggleFavorite(tournament.id);
                                          },
                                        );
                                      },
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                          showQuantitySelector: false,
                                          item: viewModel.items[index],
                                          onTapAdd: () {
                                            viewModel.addItem(
                                                viewModel.items[index]);
                                          },
                                          onTapRemove: () {
                                            viewModel.removeItem(
                                                viewModel.items[index]);
                                          },
                                        );
                                      },
                                    ),
                              SizedBox(height: 20.h),
                              if (viewModel.hasMoreResults)
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: SmallButton(
                                      title: 'Show More',
                                      onTap: () {
                                        if (viewModel.isTournamentSearch ==
                                            true) {
                                          viewModel.loadMoreTournaments();
                                        }
                                        if (viewModel.isItemSearch == true) {
                                          viewModel.loadMoreItems();
                                        }
                                      },
                                      bgColor: AppColors.white,
                                      textColor: AppColors.secondary,
                                      borderColor: AppColors.secondary,
                                      isLoading: viewModel.isLoading,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
            ),
          ],
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
