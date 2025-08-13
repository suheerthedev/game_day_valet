import 'package:floating_chat_button/floating_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_search_bar/main_search_bar.dart';
import 'package:game_day_valet/ui/widgets/common/main_tournament_card/main_tournament_card.dart';
import 'package:game_day_valet/ui/widgets/common/secondary_tournament_card/secondary_tournament_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
        appBar: MainAppBar(
          title: Column(
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
        ),
        body: SafeArea(
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                      ),
                      child: Column(
                        children: [
                          MainSearchBar(
                            controller: viewModel.searchController,
                            hintText:
                                'Search tournament by name, date, and etc',
                            isAutoFocus: false,
                            isReadOnly: true,
                            onTextFieldTap: () {
                              viewModel.navigateToSearchView(
                                  viewModel.searchController.text);
                            },
                          ),
                          SizedBox(height: 20.h),
                          Expanded(
                            child: viewModel.selectedSport.isEmpty
                                ? _buildSportSelector(context, viewModel)
                                : SizedBox(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${viewModel.selectedSport} Tournaments',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textPrimary),
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
                                                              .tournamentsList[
                                                          index],
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
                                            ],
                                          ),
                                          //Recommended Tournaments
                                          SizedBox(height: 20.h),
                                          viewModel.recommendedTournamentsList
                                                  .isEmpty
                                              ? const SizedBox.shrink()
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Recommended Tournaments',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .textPrimary),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 201.h,
                                                      child: ListView.builder(
                                                        itemCount: viewModel
                                                            .recommendedTournamentsList
                                                            .length,
                                                        shrinkWrap: true,
                                                        // physics:
                                                        //     const NeverScrollableScrollPhysics(),
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
                                                              onTapFavorite:
                                                                  () {
                                                                viewModel.toggleFavorite(
                                                                    viewModel
                                                                        .recommendedTournamentsList[
                                                                            index]
                                                                        .id);
                                                              });
                                                        },
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
                    FloatingChatButton(
                      onTap: (_) {
                        viewModel.onChatTap();
                      },
                      chatIconWidget: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Icon(
                          Iconsax.message_2_copy,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                      messageBackgroundColor: AppColors.secondary,
                      chatIconBorderColor: AppColors.secondary,
                      chatIconBackgroundColor: AppColors.secondary,
                      messageBorderWidth: 2,
                      messageText: "You've received a message!",
                      messageTextStyle: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white),
                      showMessageParameters: ShowMessageParameters(
                          delayDuration: const Duration(seconds: 2),
                          durationToShowMessage: const Duration(seconds: 5)),
                    )
                  ],
                ),
        ));
  }

  Widget _buildSportSelector(BuildContext context, HomeViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Select Sport To Begin: ${viewModel.selectedSport}',
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
                  builder: (context, scrollController) => Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.r),
                        topRight: Radius.circular(25.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        viewModel.isBusy
                            ? const Center(child: CircularProgressIndicator())
                            : Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: viewModel.sportsList.length,
                                  itemBuilder: (context, index) {
                                    final sport = viewModel.sportsList[index];
                                    final isSelected =
                                        viewModel.selectedSport == sport.name;

                                    return InkWell(
                                      onTap: () {
                                        viewModel.selectedSport =
                                            sport.name ?? '';
                                        Navigator.pop(context);
                                        viewModel
                                            .getTournamentsBySport(sport.id);
                                        viewModel.getRecommendedTournaments();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 16.h),
                                        margin: EdgeInsets.only(bottom: 8.h),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              sport.name ?? '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check,
                                                color: AppColors.primary,
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
                  border: BoxBorder.all(width: 1.04.w, color: AppColors.white),
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
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) async {
    await viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
