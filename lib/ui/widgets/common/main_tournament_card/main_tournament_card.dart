import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'main_tournament_card_model.dart';

class MainTournamentCard extends StackedView<MainTournamentCardModel> {
  final TournamentModel tournament;
  final Function() onBookNowTap;
  final Function() onTapFavorite;
  final Function() onTapMap;
  const MainTournamentCard(
      {super.key,
      required this.tournament,
      required this.onBookNowTap,
      required this.onTapFavorite,
      required this.onTapMap});

  @override
  Widget builder(
    BuildContext context,
    MainTournamentCardModel viewModel,
    Widget? child,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBookNowTap,
            child: Container(
              width: 339.w,
              height: 319.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                CachedNetworkImage(
                  imageUrl: tournament.image ?? 'assets/images/dummy.jpg',
                  fit: BoxFit.cover,
                  width: 339.w,
                  height: 319.h,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(IconsaxPlusLinear.image),
                ),
                Container(
                  width: 339.w,
                  height: 319.h,
                  color: AppColors.primary.withOpacity(0.4),
                ),
                Center(
                  child: InkWell(
                    onTap: onBookNowTap,
                    child: Container(
                        width: 133.w,
                        height: 37.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5.r),
                          border:
                              BoxBorder.all(width: 1.w, color: AppColors.white),
                        ),
                        child: Center(
                          child: Text(
                            'Book Now',
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white),
                          ),
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: onTapFavorite,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h, right: 10.w),
                      child: Icon(
                          tournament.isFavorite
                              ? IconsaxPlusBold.heart
                              : IconsaxPlusLinear.heart,
                          size: 20.w,
                          color: tournament.isFavorite
                              ? AppColors.favorite
                              : AppColors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: onTapMap,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
                      child: Text(
                        'Field Map View',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFE168),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(IconsaxPlusLinear.location,
                      size: 12.w, color: AppColors.textPrimary),
                  SizedBox(width: 4.w),
                  SizedBox(
                    width: 200.w,
                    child: Text(tournament.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '4.8',
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.star, size: 16.w, color: AppColors.primary)
                ],
              )
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            tournament.location ?? '',
            style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightText),
          ),
          Text(
            '${DateFormat('MMM d').format(DateTime.parse(tournament.startDate ?? ''))} - ${DateFormat('MMM d').format(DateTime.parse(tournament.endDate ?? ''))}',
            style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightText),
          ),
          SizedBox(height: 4.h),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: '500 HKD / hr · ',
              style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
            TextSpan(
              text: 'Discounted if booked longer',
              style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.textHint),
            ),
          ]))
        ],
      ),
    );
  }

  @override
  MainTournamentCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainTournamentCardModel();
}
