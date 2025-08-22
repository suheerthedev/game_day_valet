import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: viewModel
                    .refreshCity, // tapping "Select City" re-tries detection
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 100.w,
                      ),
                      child: Text('Select City',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
              FutureBuilder<String>(
                future: viewModel.cityFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Text('Detecting...',
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary));
                  }
                  if (snap.hasError) {
                    return InkWell(
                      onTap: viewModel.refreshCity,
                      child: Text('Enable location & tap to retry',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary)),
                    );
                  }
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 200.w,
                    ),
                    child: Text(
                      snap.data ?? 'Unknown',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : viewModel.sportsList.isEmpty
                  ? _buildEmptyState()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.w,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sports',
                                      style: GoogleFonts.poppins(
                                          fontSize: 21.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary),
                                    ),
                                    Text(
                                      'Select a sport to begin exploring tournaments.',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: viewModel.sportsList.length,
                                      itemBuilder: (context, index) {
                                        final sport =
                                            viewModel.sportsList[index];
                                        return InkWell(
                                          onTap: () {
                                            viewModel.navigateToTournaments(
                                                sport.name ?? '', sport.id);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 339.w,
                                                    height: 319.h,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.r),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: Stack(children: [
                                                      CachedNetworkImage(
                                                        imageUrl:
                                                            sport.imageUrl ??
                                                                '',
                                                        fit: BoxFit.contain,
                                                        width: 339.w,
                                                        height: 319.h,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                          IconsaxPlusLinear
                                                              .image,
                                                          color:
                                                              AppColors.grey300,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 339.w,
                                                        height: 319.h,
                                                        color: AppColors.primary
                                                            .withOpacity(0.7),
                                                      ),
                                                      Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              viewModel
                                                                      .sportsList[
                                                                          index]
                                                                      .name ??
                                                                  '',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize:
                                                                      24.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              sport.description ??
                                                                  '',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize:
                                                                      24.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                  ),
                                                ],
                                              )),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ));
  }

  // Widget _buildSportSelector(BuildContext context, HomeViewModel viewModel) {
  //   return Center(
  //     child: viewModel.isSportsLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text('Select Sport To Begin: ${viewModel.selectedSport}',
  //                   style: GoogleFonts.poppins(
  //                       fontSize: 18.sp,
  //                       fontWeight: FontWeight.w700,
  //                       color: AppColors.textPrimary)),
  //               SizedBox(height: 10.h),
  //               InkWell(
  //                 onTap: () {
  //                   showModalBottomSheet(
  //                     context: context,
  //                     backgroundColor: Colors.transparent,
  //                     builder: (context) => DraggableScrollableSheet(
  //                       initialChildSize: 0.8,
  //                       minChildSize: 0.6,
  //                       maxChildSize: 0.85,
  //                       builder: (context, scrollController) => Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 20.w, vertical: 20.h),
  //                         decoration: BoxDecoration(
  //                           color: AppColors.white,
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(25.r),
  //                             topRight: Radius.circular(25.r),
  //                           ),
  //                         ),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Select Sport',
  //                               style: GoogleFonts.poppins(
  //                                 fontSize: 20.sp,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: AppColors.textPrimary,
  //                               ),
  //                             ),
  //                             SizedBox(height: 5.h),
  //                             Text(
  //                               'Select a sport to begin exploring tournaments.',
  //                               style: GoogleFonts.poppins(
  //                                 fontSize: 14.sp,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: AppColors.textHint,
  //                               ),
  //                             ),
  //                             SizedBox(height: 20.h),
  //                             viewModel.isBusy
  //                                 ? const Center(
  //                                     child: CircularProgressIndicator())
  //                                 : Expanded(
  //                                     child: ListView.builder(
  //                                       controller: scrollController,
  //                                       itemCount: viewModel.sportsList.length,
  //                                       itemBuilder: (context, index) {
  //                                         final sport =
  //                                             viewModel.sportsList[index];
  //                                         final isSelected =
  //                                             viewModel.selectedSport ==
  //                                                 sport.name;

  //                                         return InkWell(
  //                                           onTap: () {
  //                                             viewModel.selectedSport =
  //                                                 sport.name ?? '';
  //                                             Navigator.pop(context);
  //                                             viewModel
  //                                                 .getTournaments(sport.id);
  //                                           },
  //                                           child: Container(
  //                                             padding: EdgeInsets.symmetric(
  //                                                 horizontal: 16.w,
  //                                                 vertical: 16.h),
  //                                             margin:
  //                                                 EdgeInsets.only(bottom: 8.h),
  //                                             decoration: BoxDecoration(
  //                                               color: AppColors.white,
  //                                               border: Border(
  //                                                 top: BorderSide(
  //                                                   color: AppColors.textHint
  //                                                       .withOpacity(0.1),
  //                                                   width: 1,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             child: Row(
  //                                               mainAxisAlignment:
  //                                                   MainAxisAlignment
  //                                                       .spaceBetween,
  //                                               children: [
  //                                                 ConstrainedBox(
  //                                                   constraints: BoxConstraints(
  //                                                     maxWidth: 0.8.sw,
  //                                                   ),
  //                                                   child: Text(
  //                                                     sport.name ?? '',
  //                                                     maxLines: 1,
  //                                                     overflow:
  //                                                         TextOverflow.ellipsis,
  //                                                     softWrap: true,
  //                                                     style:
  //                                                         GoogleFonts.poppins(
  //                                                       fontSize: 16.sp,
  //                                                       fontWeight:
  //                                                           FontWeight.w500,
  //                                                       color: AppColors
  //                                                           .textPrimary,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 if (isSelected)
  //                                                   Icon(
  //                                                     Icons.check,
  //                                                     color: AppColors.primary,
  //                                                     size: 20.sp,
  //                                                   ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         );
  //                                       },
  //                                     ),
  //                                   ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                     width: 140.w,
  //                     height: 40.h,
  //                     decoration: BoxDecoration(
  //                       color: AppColors.secondary,
  //                       borderRadius: BorderRadius.circular(10.r),
  //                       border:
  //                           Border.all(width: 1.04.w, color: AppColors.white),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         'Select',
  //                         style: GoogleFonts.poppins(
  //                             fontSize: 16.sp,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.white),
  //                       ),
  //                     )),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusBold.play, size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No sports found',
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
