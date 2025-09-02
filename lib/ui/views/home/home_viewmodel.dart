import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/models/sports_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/pusher_service.dart';
import 'package:game_day_valet/services/sports_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _pusherService = locator<PusherService>();
  final _sportsService = locator<SportsService>();

  List<SportsModel> get sportsList => _sportsService.sports;

  String selectedSport = ''; // Default selected sport

  TextEditingController searchController = TextEditingController();

  Future<void> init() async {
    await _pusherService.initialize();
    await getSports();
  }

  void clearSports() {
    _sportsService.clearSports();
    rebuildUi();
  }

  void navigateToTournaments(String sportsName, int sportId) {
    _navigationService.navigateToTournamentsView(
        sportId: sportId, sportsName: sportsName);
  }

  bool isSportsLoading = false;

  Future<void> getSports() async {
    isSportsLoading = true;
    rebuildUi();

    try {
      await _sportsService.getSports();
    } on ApiException catch (e) {
      logger.error("Error fetching sports", e);
      _snackbarService.showCustomSnackBar(
          title: 'Error', message: e.toString(), variant: SnackbarType.error);
    } catch (e) {
      logger.error("Error fetching sports", e);
      _snackbarService.showCustomSnackBar(
          title: 'Error', message: e.toString(), variant: SnackbarType.error);
    } finally {
      isSportsLoading = false;
      rebuildUi();
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.899983957647624, 67.10959149999998),
    zoom: 14.4746,
  );

  void showMapPopup(BuildContext context) {
    logger.info('Google Map Popup Triggered');

    // Create a new completer for each popup instance
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.green.shade100, // Simulated map background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: 252.w,
                  height: 148.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      if (!mapController.isCompleted) {
                        mapController.complete(controller);
                      }
                    },
                  ),
                )),
          ),
        );
      },
    );
  }
}
