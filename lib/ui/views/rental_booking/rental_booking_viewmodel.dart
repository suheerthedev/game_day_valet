import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class RentalBookingViewModel extends BaseViewModel {
  bool smartSuggestion = false;
  bool insuranceOne = false;
  bool insuranceTwo = false;
  bool damageWaiver = false;
  bool stripe = false;
  bool applePay = false;
  bool googlePay = false;

  bool isGearExpanded = false;

  List<Map<String, dynamic>> gears = [
    {
      'name': 'Fans',
      'image': 'assets/images/fan.jpeg',
    },
    {
      'name': 'Tents',
      'image': 'assets/images/tent.png',
    },
    {
      'name': 'Coolers',
      'image': 'assets/images/cooler.png',
    },
    {
      'name': 'Speakers',
      'image': 'assets/images/speaker.png',
    },
  ];

  final TextEditingController tournamentController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController coachNameController = TextEditingController();
  final TextEditingController ageGroupController = TextEditingController();
  final TextEditingController gearNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();
  final TextEditingController specialInstructionController =
      TextEditingController();

  void showMapPopup(BuildContext context, String image, String name) {
    logger.info('Google Map Popup Triggered');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                width: 288.w,
                height: 292.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        )),
                    SizedBox(height: 10.h),
                    Container(
                      width: 255.w,
                      height: 219.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
