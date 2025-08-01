import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/models/sports_model.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  String selectedSport = ''; // Default selected sport

  List<SportsModel> sportsList = [];

  final List<String> sports = [
    'Soccer',
    'Baseball',
    'Softball',
    'Lacrosse',
    'Football',
  ];

  Future<void> getSports() async {
    final url = ApiConfig.baseUrl + ApiConfig.sportsEndPoint;

    try {
      final response = await _apiService.get(url);

      final data = response['data'];

      for (var item in data) {
        sportsList.add(SportsModel.fromJson(item));
      }

      notifyListeners();
    } on ApiException catch (e) {
      logger.error("Error fetching sports", e);
    } catch (e) {
      logger.error("Error fetching sports", e);
    }
  }

  List<TournamentModel> tournamentsList = [];

  Future<void> getTournamentsBySport(int sportId) async {
    final url =
        '${ApiConfig.baseUrl}${ApiConfig.tournamentsBySportEndPoint}/$sportId';

    setBusy(true);

    try {
      final response = await _apiService.get(url);

      final data = response['data'];

      for (var item in data) {
        tournamentsList.add(TournamentModel.fromJson(item));
      }

      logger.info("Tournaments fetched successfully");
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
    } catch (e) {
      logger.error("Error fetching tournaments", e);
    } finally {
      notifyListeners();
      setBusy(false);
    }
  }

  void onChatTap() {
    _navigationService.navigateToChatView();
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
