import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:game_day_valet/ui/widgets/common/main_app_bar/main_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:stacked/stacked.dart';

import 'favorites_viewmodel.dart';

class FavoritesView extends StackedView<FavoritesViewModel> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FavoritesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: MainAppBar(
          title: Text(
            'Favorites',
            style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : viewModel.favorites.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.favorites.length,
                            itemBuilder: (context, index) {
                              final favorite = viewModel.favorites[index];
                              return Container(
                                width: 338.w,
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: AppColors.grey900,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 36.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10.r), // Adjust the radius as needed
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  favorite.tournament?.image ??
                                                      '',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                      Icons
                                                          .sports_soccer_rounded,
                                                      size: 40.w,
                                                      color: AppColors.white),
                                              fit: BoxFit.cover,
                                              width: double.maxFinite,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                              viewModel.favorites[index]
                                                      .tournament?.name ??
                                                  '',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.textPrimary)),
                                          SizedBox(height: 5.h),
                                          Text(
                                            'Location: ${favorite.tournament?.location}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textHint),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            'Start Date: ${DateFormat.yMMMd().format(DateTime.parse(favorite.tournament?.startDate.toString() ?? ''))}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textHint),
                                          ),
                                          Text(
                                            'End Date: ${DateFormat.yMMMd().format(DateTime.parse(favorite.tournament?.endDate.toString() ?? ''))}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textHint),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(Iconsax.heart,
                                          size: 24.w,
                                          color: AppColors.secondary),
                                    ),
                                    // Align(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: InkWell(
                                    //     onTap: () {},
                                    //     child: Container(
                                    //         width: 121.w,
                                    //         height: 33.h,
                                    //         decoration: BoxDecoration(
                                    //           color: AppColors.secondary,
                                    //           borderRadius:
                                    //               BorderRadius.circular(10.r),
                                    //         ),
                                    //         child: Center(
                                    //           child: Text(
                                    //             'Order Again',
                                    //             style: GoogleFonts.poppins(
                                    //                 fontSize: 16.sp,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: AppColors.white),
                                    //           ),
                                    //         )),
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
        )));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.heart, size: 40.w, color: AppColors.secondary),
          SizedBox(height: 10.h),
          Text(
            'No favorites yet',
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
  FavoritesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FavoritesViewModel();

  @override
  void onViewModelReady(FavoritesViewModel viewModel) {
    viewModel.getFavorites();
    super.onViewModelReady(viewModel);
  }
}
