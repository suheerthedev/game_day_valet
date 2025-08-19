import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_day_valet/services/location_service.dart';
import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/app/app.router.dart';
import 'package:game_day_valet/config/api_config.dart';
import 'package:game_day_valet/core/enums/snackbar_type.dart';
import 'package:game_day_valet/models/sports_model.dart';
import 'package:game_day_valet/models/tournament_model.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/api_service.dart';
import 'package:game_day_valet/services/logger_service.dart';
import 'package:game_day_valet/services/pusher_service.dart';
import 'package:game_day_valet/services/tournament_service.dart';
import 'package:game_day_valet/ui/common/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _tournamentService = locator<TournamentService>();
  final _snackbarService = locator<SnackbarService>();
  final _pusherService = locator<PusherService>();
  final _locationService = locator<LocationService>();

  late Future<String> _cityFuture;

  HomeViewModel() {
    _cityFuture = _locationService.getCityAndCountry();
  }

  Future<String> get cityFuture => _cityFuture;

  String selectedSport = ''; // Default selected sport

  TextEditingController searchController = TextEditingController();

  List<TournamentModel> get tournamentsList =>
      _tournamentService.tournamentsBySport;
  List<TournamentModel> get recommendedTournamentsList =>
      _tournamentService.recommendedTournaments;
  List<SportsModel> sportsList = [];

  // Tournaments by sport
  int selectedSportId = 0;
  int currentPageForTournamentsBySport = 1;
  int get lastPageForTournamentsBySport =>
      _tournamentService.lastPageForTournamentsBySport;
  bool get hasMoreTournamentsBySport =>
      currentPageForTournamentsBySport <= lastPageForTournamentsBySport;
  bool isLoadingMoreTournamentsBySport = false;

  // Recommended tournaments
  int currentPageForRecommendedTournaments = 1;
  int get lastPageForRecommendedTournaments =>
      _tournamentService.lastPageForRecommendedTournaments;
  bool get hasMoreRecommendedTournaments =>
      currentPageForRecommendedTournaments <= lastPageForRecommendedTournaments;
  bool isLoadingMoreRecommendedTournaments = false;

  void navigateToSearchView(String searchQuery) {
    _navigationService.navigateToSearchView(isTournamentSearch: true);
  }

  void navigateToRentalBook(int tournamentId) {
    _navigationService.navigateToAddRentalsView(tournamentId: tournamentId);
  }

  Future<void> init() async {
    await _pusherService.initialize();
    await getSports();
  }

  void refreshCity() {
    _cityFuture = _locationService.getCityAndCountry();
    rebuildUi();
  }

  bool isSportsLoading = false;

  Future<void> getSports() async {
    final url = ApiConfig.baseUrl + ApiConfig.sportsEndPoint;

    isSportsLoading = true;
    rebuildUi();

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
    } finally {
      isSportsLoading = false;
      rebuildUi();
    }
  }

  void getTournaments(int sportId) async {
    selectedSportId = sportId;
    setBusy(true);
    rebuildUi();
    try {
      await getTournamentsBySport(sportId);
      await getRecommendedTournaments();
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
    } catch (e) {
      logger.error("Error fetching tournaments", e);
    } finally {
      rebuildUi();
      setBusy(false);
    }
  }

  Future<void> getTournamentsBySport(int sportId) async {
    try {
      await _tournamentService.getTournamentsBySport(sportId);
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    }
  }

  Future<void> loadMoreTournamentsBySport(int sportId) async {
    isLoadingMoreTournamentsBySport = true;
    rebuildUi();
    try {
      await _tournamentService.getTournamentsBySport(sportId,
          page: ++currentPageForTournamentsBySport);
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    } finally {
      isLoadingMoreTournamentsBySport = false;
      rebuildUi();
    }
  }

  Future<void> getRecommendedTournaments() async {
    try {
      await _tournamentService.getRecommendedTournaments();
    } on ApiException catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching recommended tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    }
  }

  Future<void> loadMoreRecommendedTournaments() async {
    isLoadingMoreRecommendedTournaments = true;
    rebuildUi();
    try {
      await _tournamentService.getRecommendedTournaments(
          page: ++currentPageForRecommendedTournaments);
    } on ApiException catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error fetching tournaments", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: "Something went wrong",
      );
    } finally {
      isLoadingMoreRecommendedTournaments = false;
      rebuildUi();
    }
  }

  void toggleFavorite(int tournamentId) async {
    final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

    int index =
        tournamentsList.indexWhere((element) => element.id == tournamentId);

    int indexRecommended = recommendedTournamentsList
        .indexWhere((element) => element.id == tournamentId);

    logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
    tournamentsList[index].isFavorite = !tournamentsList[index].isFavorite;
    recommendedTournamentsList[indexRecommended].isFavorite =
        !recommendedTournamentsList[indexRecommended].isFavorite;
    logger.info("Is Favorite: ${tournamentsList[index].isFavorite}");
    logger.info(
        "Is Favorite: ${recommendedTournamentsList[indexRecommended].isFavorite}");
    rebuildUi();

    try {
      final response = await _apiService.post(url, {
        "tournament_id": tournamentId.toString(),
      });

      logger.info("Favorite toggled successfully. Response: $response");
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        message: response['message'],
      );
    } on ApiException catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.message,
      );
    } catch (e) {
      logger.error("Error toggling favorite", e);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        message: e.toString(),
      );
    } finally {
      rebuildUi();
    }
  }

  // void toggleFavoriteRecommendedTournaments(
  //     String tournamentId, int index) async {
  //   final url = ApiConfig.baseUrl + ApiConfig.toggleFavoriteEndPoint;

  //   logger.info("Is Favorite: ${recommendedTournamentsList[index].isFavorite}");
  //   recommendedTournamentsList[index].isFavorite =
  //       !recommendedTournamentsList[index].isFavorite;
  //   logger.info("Is Favorite: ${recommendedTournamentsList[index].isFavorite}");
  //   rebuildUi();

  //   try {
  //     final response = await _apiService.post(url, {
  //       "tournament_id": tournamentId,
  //     });

  //     logger.info("Favorite toggled successfully. Response: $response");
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.success,
  //       message: response['message'],
  //     );
  //   } on ApiException catch (e) {
  //     logger.error("Error toggling favorite", e);
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.error,
  //       message: e.message,
  //     );
  //   } catch (e) {
  //     logger.error("Error toggling favorite", e);
  //     _snackbarService.showCustomSnackBar(
  //       variant: SnackbarType.error,
  //       message: e.toString(),
  //     );
  //   } finally {
  //     rebuildUi();
  //   }
  // }

  void onChatTap() {
    _navigationService.navigateToInboxView();
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
