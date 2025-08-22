import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_tournament_card/main_tournament_card.dart';
import 'package:game_day_valet/ui/widgets/common/secondary_tournament_card/secondary_tournament_card.dart';
import 'package:game_day_valet/ui/widgets/common/small_button/small_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';

import 'tournaments_viewmodel.dart';

class TournamentsView extends StackedView<TournamentsViewModel> {
  final String sportsName;
  final int sportId;
  const TournamentsView({
    Key? key,
    required this.sportsName,
    required this.sportId,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TournamentsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: MainAppBar(
        title: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.6.sw,
          ),
          child: Text(
            sportsName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : viewModel.tournamentsList.isEmpty &&
                    viewModel.recommendedTournamentsList.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                    ),
                    child: Column(
                      children: [
                        MainSearchBar(
                          controller: viewModel.searchController,
                          hintText: 'Search tournament by name, date, and etc',
                          isAutoFocus: false,
                          isReadOnly: true,
                          onTextFieldTap: () {
                            viewModel.navigateToSearchView(
                                viewModel.searchController.text);
                          },
                        ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  viewModel.tournamentsList.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '$sportsName Tournaments',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 21.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: viewModel
                                                  .tournamentsList.length,
                                              itemBuilder: (context, index) {
                                                return MainTournamentCard(
                                                    tournament: viewModel
                                                        .tournamentsList[index],
                                                    onBookNowTap: () {
                                                      viewModel
                                                          .navigateToRentalBook(
                                                              viewModel
                                                                  .tournamentsList[
                                                                      index]
                                                                  .id);
                                                    },
                                                    onTapFavorite: () {
                                                      viewModel.toggleFavorite(
                                                          viewModel
                                                              .tournamentsList[
                                                                  index]
                                                              .id);
                                                    },
                                                    onTapMap: () {
                                                      viewModel.showMapPopup(
                                                          context);
                                                    });
                                              },
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            if (viewModel
                                                .hasMoreTournamentsBySport)
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 32.w),
                                                  child: SmallButton(
                                                    title: 'Show More',
                                                    onTap: () {
                                                      viewModel
                                                          .loadMoreTournamentsBySport();
                                                    },
                                                    bgColor: AppColors.white,
                                                    textColor:
                                                        AppColors.secondary,
                                                    borderColor:
                                                        AppColors.secondary,
                                                    isLoading: viewModel
                                                        .isLoadingMoreTournamentsBySport,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                  //Recommended Tournaments
                                  SizedBox(height: 20.h),
                                  viewModel.recommendedTournamentsList.isEmpty
                                      ? const SizedBox.shrink()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Recommended Tournaments',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary),
                                            ),
                                            SizedBox(height: 10.h),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 201.h,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    ListView.builder(
                                                      itemCount: viewModel
                                                          .recommendedTournamentsList
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return SecondaryTournamentCard(
                                                            tournament: viewModel
                                                                    .recommendedTournamentsList[
                                                                index],
                                                            onBookNowTap: () {
                                                              viewModel.navigateToRentalBook(
                                                                  viewModel
                                                                      .recommendedTournamentsList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            onTapFavorite: () {
                                                              viewModel.toggleFavorite(
                                                                  viewModel
                                                                      .recommendedTournamentsList[
                                                                          index]
                                                                      .id);
                                                            });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10.h,
                                                    ),
                                                    if (viewModel
                                                        .hasMoreRecommendedTournaments)
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      32.w),
                                                          child: SmallButton(
                                                            title: 'Show More',
                                                            onTap: () {
                                                              viewModel
                                                                  .loadMoreRecommendedTournaments();
                                                            },
                                                            bgColor:
                                                                AppColors.white,
                                                            textColor: AppColors
                                                                .secondary,
                                                            borderColor:
                                                                AppColors
                                                                    .secondary,
                                                            isLoading: viewModel
                                                                .isLoadingMoreRecommendedTournaments,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusBold.play, size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No tournaments found',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  @override
  TournamentsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TournamentsViewModel(sportsName: sportsName, sportId: sportId);

  @override
  void onViewModelReady(TournamentsViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(TournamentsViewModel viewModel) {
    viewModel.clearTournaments();
    super.onDispose(viewModel);
  }
}
